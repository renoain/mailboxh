<?php

declare(strict_types=1);

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ListResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'user_id' => $this->user_id,
            'owner_name' => $this->whenLoaded('user', fn () => $this->user->name),
            'title' => $this->title,
            'description' => $this->description,
            'is_public' => (bool) $this->is_public,
            'item_count' => $this->whenCounted('items'),
            'can_edit' => $request->user()?->id === $this->user_id,
            'created_at' => $this->created_at?->toIso8601String(),
        ];
    }
}
