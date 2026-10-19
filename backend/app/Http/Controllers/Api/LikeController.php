<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Requests\StoreLikeRequest;
use App\Http\Resources\LikeResource;
use App\Http\Traits\ApiResponse;
use App\Models\Like;
use App\Models\Movie;
use App\Models\MovieList;
use App\Models\Review;
use App\Services\ActivityLogger;
use App\Services\NotificationService;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class LikeController extends Controller
{
    use ApiResponse;

    public function __construct(private readonly NotificationService $notifications)
    {
    }

    public function index(Request $request): JsonResponse
    {
        $items = $request->user()->likes()->with('likeable')->latest()->get();

        return $this->success(LikeResource::collection($items)->resolve($request));
    }

    public function store(StoreLikeRequest $request, ActivityLogger $logger): JsonResponse
    {
        $userId = $request->user()->id;
        $likeableId = $request->integer('likeable_id');
        $likeableType = $request->string('likeable_type')->toString();

        $likeable = $this->resolveLikeable($likeableType, $likeableId);

        if ($likeable === null) {
            return $this->failure('Data yang di-like tidak ditemukan.', 404);
        }

        $exists = Like::where('user_id', $userId)
            ->where('likeable_id', $likeableId)
            ->where('likeable_type', $likeableType)
            ->exists();

        if ($exists) {
            return $this->failure('Data sudah di-like.', 409);
        }

        $like = Like::create([
            'user_id' => $userId,
            'likeable_id' => $likeableId,
            'likeable_type' => $likeableType,
        ]);

        $logger->log($userId, ActivityLogger::TYPE_LIKED, $like->id, [
            'likeable_type' => $likeableType,
            'likeable_id' => $likeableId,
        ]);

        $this->notifyOwner($likeable, $userId, $like->id);

        return $this->success([
            'likeable_id' => $likeableId,
            'likeable_type' => $likeableType,
            'liked' => true,
            'like_count' => $this->likeCount($likeableType, $likeableId),
        ], null, 201);
    }

    public function destroy(StoreLikeRequest $request): JsonResponse
    {
        $userId = $request->user()->id;
        $likeableId = $request->integer('likeable_id');
        $likeableType = $request->string('likeable_type')->toString();

        $deleted = Like::where('user_id', $userId)
            ->where('likeable_id', $likeableId)
            ->where('likeable_type', $likeableType)
            ->delete();

        if ($deleted === 0) {
            return $this->failure('Data belum di-like.', 404);
        }

        return $this->success([
            'likeable_id' => $likeableId,
            'likeable_type' => $likeableType,
            'liked' => false,
            'like_count' => $this->likeCount($likeableType, $likeableId),
        ]);
    }

    private function resolveLikeable(string $type, int $id): ?Model
    {
        return match ($type) {
            Movie::class => Movie::find($id),
            Review::class => Review::find($id),
            MovieList::class => MovieList::find($id),
            default => null,
        };
    }

    private function notifyOwner(Model $likeable, int $actorId, int $likeId): void
    {
        if ($likeable instanceof Review) {
            $this->notifications->forLikeReview((int) $likeable->user_id, $actorId, $likeId);
        } elseif ($likeable instanceof MovieList) {
            $this->notifications->forLikeList((int) $likeable->user_id, $actorId, $likeId);
        }
    }

    private function likeCount(string $type, int $id): int
    {
        return Like::where('likeable_id', $id)->where('likeable_type', $type)->count();
    }
}
