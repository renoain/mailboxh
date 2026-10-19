<?php

declare(strict_types=1);

namespace Database\Factories;

use App\Models\Like;
use App\Models\Movie;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

// Factory tanda suka polymorphic.
class LikeFactory extends Factory
{
    protected $model = Like::class;

    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'likeable_id' => Movie::factory(),
            'likeable_type' => Movie::class,
        ];
    }
}
