<?php

declare(strict_types=1);

namespace Tests\Feature;

use App\Models\Movie;
use App\Models\Review;
use App\Models\User;
use App\Models\Watchlist;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

// Test rating bintang berdiri sendiri tanpa entri diary.
class RatingTest extends TestCase
{
    use RefreshDatabase;

    public function test_rate_tanpa_log(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user);
        $movie = Movie::factory()->create();

        $response = $this->postJson('/api/movies/'.$movie->id.'/rate', ['rating' => 4]);

        $response->assertStatus(201)->assertJsonPath('data.rating', 4);
        $this->assertDatabaseHas('reviews', [
            'user_id' => $user->id,
            'movie_id' => $movie->id,
            'rating' => 4,
        ]);
        $this->assertDatabaseMissing('diary_entries', [
            'user_id' => $user->id,
            'movie_id' => $movie->id,
        ]);
    }

    public function test_rate_hapus_dari_watchlist(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user);
        $movie = Movie::factory()->create();
        Watchlist::create(['user_id' => $user->id, 'movie_id' => $movie->id]);

        $this->postJson('/api/movies/'.$movie->id.'/rate', ['rating' => 5]);

        $this->assertDatabaseMissing('watchlist', [
            'user_id' => $user->id,
            'movie_id' => $movie->id,
        ]);
    }

    public function test_unrate(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user);
        $movie = Movie::factory()->create();
        Review::factory()->create(['user_id' => $user->id, 'movie_id' => $movie->id]);

        $response = $this->deleteJson('/api/movies/'.$movie->id.'/rate');

        $response->assertStatus(200);
        $this->assertDatabaseMissing('reviews', [
            'user_id' => $user->id,
            'movie_id' => $movie->id,
        ]);
    }

    public function test_unrate_tidak_ada(): void
    {
        Sanctum::actingAs(User::factory()->create());
        $movie = Movie::factory()->create();

        $response = $this->deleteJson('/api/movies/'.$movie->id.'/rate');

        $response->assertStatus(404);
    }

    public function test_rate_validasi(): void
    {
        Sanctum::actingAs(User::factory()->create());
        $movie = Movie::factory()->create();

        $response = $this->postJson('/api/movies/'.$movie->id.'/rate', ['rating' => 6]);

        $response->assertStatus(422);
    }

    public function test_rate_film_tidak_ada(): void
    {
        Sanctum::actingAs(User::factory()->create());

        $response = $this->postJson('/api/movies/9999/rate', ['rating' => 3]);

        $response->assertStatus(404);
    }
}
