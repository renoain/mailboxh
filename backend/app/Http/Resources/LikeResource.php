<?php

declare(strict_types=1);

namespace App\Http\Resources;

use App\Models\Movie;
use App\Models\MovieList;
use App\Models\Review;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class LikeResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'likeable_id' => $this->likeable_id,
            'likeable_type' => $this->likeable_type,
            'likeable' => $this->whenLoaded('likeable', fn () => $this->likeableSummary()),
            'liked_at' => $this->created_at?->toIso8601String(),
        ];
    }

    /**
     * Ringkasan likeable agar respons tetap ringan.
     *
     * @return array<string, mixed>|null
     */
    private function likeableSummary(): ?array
    {
        $likeable = $this->likeable;

        if ($likeable instanceof Movie) {
            return ['id' => $likeable->id, 'title' => $likeable->title, 'poster_path' => $likeable->poster_path];
        }

        if ($likeable instanceof MovieList) {
            return ['id' => $likeable->id, 'title' => $likeable->title];
        }

        if ($likeable instanceof Review) {
            return ['id' => $likeable->id, 'content' => $likeable->content];
        }

        return null;
    }
}
