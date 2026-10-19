<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Requests\StoreCommentRequest;
use App\Http\Traits\ApiResponse;
use App\Models\Comment;
use App\Models\Review;
use App\Services\NotificationService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CommentController extends Controller
{
    use ApiResponse;

    public function __construct(private readonly NotificationService $notifications)
    {
    }

    public function index(Request $request, int $id): JsonResponse
    {
        $review = Review::find($id);

        if ($review === null) {
            return $this->failure('Review tidak ditemukan.', 404);
        }

        $comments = $review->comments()->with('user')->latest()->get();

        return $this->success($comments->map(fn (Comment $comment) => $this->shape($comment, $comment->user->name))->all());
    }

    public function store(StoreCommentRequest $request, int $id): JsonResponse
    {
        $review = Review::find($id);

        if ($review === null) {
            return $this->failure('Review tidak ditemukan.', 404);
        }

        $comment = Comment::create([
            'review_id' => $review->id,
            'user_id' => $request->user()->id,
            'content' => $request->string('content')->toString(),
        ]);

        $this->notifications->forComment((int) $review->user_id, $request->user()->id, $comment->id);

        return $this->success($this->shape($comment, $request->user()->name), null, 201);
    }

    public function destroy(Request $request, int $id): JsonResponse
    {
        $comment = Comment::find($id);

        if ($comment === null) {
            return $this->failure('Komentar tidak ditemukan.', 404);
        }

        $isOwner = $comment->user_id === $request->user()->id;
        $isAdmin = $request->user()->isAdmin();

        if (! $isOwner && ! $isAdmin) {
            return $this->failure('Anda tidak boleh menghapus komentar ini.', 403);
        }

        $comment->delete();

        return $this->success(null);
    }

    /**
     * @return array<string, mixed>
     */
    private function shape(Comment $comment, string $userName): array
    {
        return [
            'id' => $comment->id,
            'review_id' => $comment->review_id,
            'user_id' => $comment->user_id,
            'user_name' => $userName,
            'content' => $comment->content,
            'created_at' => $comment->created_at?->toIso8601String(),
        ];
    }
}
