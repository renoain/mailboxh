<?php

declare(strict_types=1);

namespace App\Services;

use App\Models\Notification;

/**
 * Satu-satunya kelas yang menulis ke tabel notifications.
 */
class NotificationService
{
    public function forLikeReview(int $recipientId, int $actorId, int $referenceId): void
    {
        $this->push($recipientId, $actorId, Notification::TYPE_LIKE_REVIEW, $referenceId);
    }

    public function forComment(int $recipientId, int $actorId, int $referenceId): void
    {
        $this->push($recipientId, $actorId, Notification::TYPE_COMMENT_REVIEW, $referenceId);
    }

    public function forFollow(int $recipientId, int $actorId, int $referenceId): void
    {
        $this->push($recipientId, $actorId, Notification::TYPE_FOLLOW, $referenceId);
    }

    public function forLikeList(int $recipientId, int $actorId, int $referenceId): void
    {
        $this->push($recipientId, $actorId, Notification::TYPE_LIKE_LIST, $referenceId);
    }

    private function push(int $recipientId, int $actorId, string $type, ?int $referenceId): void
    {
        if ($recipientId === $actorId) {
            return;
        }

        Notification::create([
            'user_id' => $recipientId,
            'actor_id' => $actorId,
            'type' => $type,
            'reference_id' => $referenceId,
        ]);
    }
}
