<?php

declare(strict_types=1);

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ReviewResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'movie_id' => $this->movie_id,
            'movie' => new MovieResource($this->whenLoaded('movie')),
            'user_id' => $this->user_id,
            'user_name' => $this->whenLoaded('user', fn () => $this->user->name),
            'rating' => $this->rating,
            'content' => $this->content,
            'updated_at' => $this->updated_at?->toIso8601String(),
        ];
    }
}
