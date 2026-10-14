<?php

declare(strict_types=1);

namespace Tests\Feature;

use App\Models\Like;
use App\Models\Movie;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

// Test endpoint like pada film.
class LikeTest extends TestCase
{
    use RefreshDatabase;

    public function test_like(): void
    {
        Sanctum::actingAs(User::factory()->create());
        $movie = Movie::factory()->create();

        $response = $this->postJson('/api/likes', ['movie_id' => $movie->id]);

        $response->assertStatus(201)->assertJsonPath('data.liked', true);
    }

    public function test_unlike(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user);
        $movie = Movie::factory()->create();
        Like::factory()->create(['user_id' => $user->id, 'movie_id' => $movie->id]);

        $response = $this->deleteJson('/api/likes/'.$movie->id);

        $response->assertStatus(200)->assertJsonPath('data.liked', false);
    }

    public function test_list(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user);
        Like::factory()->create(['user_id' => $user->id]);

        $response = $this->getJson('/api/likes');

        $response->assertStatus(200)->assertJsonCount(1, 'data');
    }
}
