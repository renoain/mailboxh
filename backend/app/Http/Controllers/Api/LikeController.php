<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Requests\StoreLikeRequest;
use App\Http\Resources\LikeResource;
use App\Http\Traits\ApiResponse;
use App\Models\Like;
use App\Services\ActivityLogger;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class LikeController extends Controller
{
    use ApiResponse;

    public function index(Request $request): JsonResponse
    {
        $items = $request->user()->likes()->with('movie.genres')->latest()->get();

        return $this->success(LikeResource::collection($items)->resolve($request));
    }

    public function show(Request $request, int $movieId): JsonResponse
    {
        return $this->success([
            'movie_id' => $movieId,
            'liked' => Like::where('user_id', $request->user()->id)->where('movie_id', $movieId)->exists(),
            'like_count' => Like::where('movie_id', $movieId)->count(),
        ]);
    }

    public function store(StoreLikeRequest $request, ActivityLogger $logger): JsonResponse
    {
        $movieId = $request->integer('movie_id');

        if (Like::where('user_id', $request->user()->id)->where('movie_id', $movieId)->exists()) {
            return $this->failure('Film sudah di-like.', 409);
        }

        $like = Like::create([
            'user_id' => $request->user()->id,
            'movie_id' => $movieId,
        ]);

        $logger->log($request->user()->id, ActivityLogger::TYPE_LIKED, $like->id, [
            'movie_id' => $movieId,
        ]);

        return $this->success([
            'movie_id' => $movieId,
            'liked' => true,
            'like_count' => Like::where('movie_id', $movieId)->count(),
        ], null, 201);
    }

    public function destroy(Request $request, int $movieId): JsonResponse
    {
        $deleted = Like::where('user_id', $request->user()->id)
            ->where('movie_id', $movieId)
            ->delete();

        if ($deleted === 0) {
            return $this->failure('Film belum di-like.', 404);
        }

        return $this->success([
            'movie_id' => $movieId,
            'liked' => false,
            'like_count' => Like::where('movie_id', $movieId)->count(),
        ]);
    }
}
