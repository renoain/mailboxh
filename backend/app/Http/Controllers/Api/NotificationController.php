<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Traits\ApiResponse;
use App\Models\Notification;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
    use ApiResponse;

    public function index(Request $request): JsonResponse
    {
        $notifications = $request->user()->notifications()
            ->with('actor')
            ->latest()
            ->limit(50)
            ->get();

        return $this->success($notifications->map(fn (Notification $notification) => [
            'id' => $notification->id,
            'type' => $notification->type,
            'reference_id' => $notification->reference_id,
            'is_read' => (bool) $notification->is_read,
            'actor' => $notification->actor === null ? null : [
                'id' => $notification->actor->id,
                'name' => $notification->actor->name,
            ],
            'created_at' => $notification->created_at?->toIso8601String(),
        ])->all());
    }

    public function markRead(Request $request, int $id): JsonResponse
    {
        $notification = $request->user()->notifications()->find($id);

        if ($notification === null) {
            return $this->failure('Notifikasi tidak ditemukan.', 404);
        }

        $notification->update(['is_read' => true]);

        return $this->success(['id' => $notification->id, 'is_read' => true]);
    }

    public function readAll(Request $request): JsonResponse
    {
        $updated = $request->user()->notifications()->where('is_read', false)->update(['is_read' => true]);

        return $this->success(['updated' => $updated]);
    }
}
