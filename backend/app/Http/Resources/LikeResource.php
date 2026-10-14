<?php

declare(strict_types=1);

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class LikeResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'movie_id' => $this->movie_id,
            'movie' => new MovieResource($this->whenLoaded('movie')),
            'liked_at' => $this->created_at?->toIso8601String(),
        ];
    }
}
