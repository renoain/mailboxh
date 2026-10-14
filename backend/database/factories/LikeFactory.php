<?php

declare(strict_types=1);

namespace Database\Factories;

use App\Models\Like;
use App\Models\Movie;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

// Factory tanda suka pada film.
class LikeFactory extends Factory
{
    protected $model = Like::class;

    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'movie_id' => Movie::factory(),
        ];
    }
}
