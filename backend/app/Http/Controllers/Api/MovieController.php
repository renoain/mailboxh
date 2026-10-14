<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Resources\MovieResource;
use App\Http\Traits\ApiResponse;
use App\Models\Genre;
use App\Models\Movie;
use App\Services\MovieStatsService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class MovieController extends Controller
{
    use ApiResponse;

    public function __construct(private readonly MovieStatsService $stats)
    {
    }

    public function index(Request $request): JsonResponse
    {
        $query = Movie::query()->with('genres');

        if ($request->filled('q')) {
            $query->where('title', 'like', '%'.$request->string('q')->toString().'%');
        }

        if ($request->filled('genre_id')) {
            $query->whereHas('genres', fn ($q) => $q->where('genres.id', $request->integer('genre_id')));
        }

        match ($request->string('sort')->toString()) {
            'title' => $query->orderBy('title'),
            'release_date' => $query->orderByDesc('release_date'),
            'rating' => $query->withAvg('reviews', 'rating')->orderByDesc('reviews_avg_rating'),
            default => $query->orderByDesc('created_at'),
        };

        $paginator = $query->paginate(20)->withQueryString();

        return $this->success(
            MovieResource::collection($paginator->getCollection())->resolve($request),
            [
                'page' => $paginator->currentPage(),
                'per_page' => $paginator->perPage(),
                'total' => $paginator->total(),
            ],
        );
    }

    public function show(Request $request, int $id): JsonResponse
    {
        $movie = Movie::with('genres')->find($id);

        if ($movie === null) {
            return $this->failure('Film tidak ditemukan.', 404);
        }

        $user = $request->user();

        $payload = MovieResource::make($movie)->additional([
            'average_rating' => $this->stats->getAverageRating($movie->id),
            'review_count' => $this->stats->getReviewCount($movie->id),
            'watched_count' => $this->stats->getWatchedCount($movie->id),
            'watchlist_count' => $this->stats->getWatchlistCount($movie->id),
            'like_count' => $movie->likes()->count(),
            'liked' => $user !== null && $movie->likes()->where('user_id', $user->id)->exists(),
            'in_watchlist' => $user !== null && $movie->watchlists()->where('user_id', $user->id)->exists(),
            'watched_at' => $user === null
                ? null
                : $movie->watcheds()->where('user_id', $user->id)->value('watched_at'),
            'diary_entry_id' => $user === null
                ? null
                : $movie->diaryEntries()->where('user_id', $user->id)->value('id'),
        ])->resolve($request);

        return $this->success($payload);
    }
}
