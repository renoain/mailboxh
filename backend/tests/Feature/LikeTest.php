<?php

declare(strict_types=1);

namespace Tests\Feature;

use App\Models\Like;
use App\Models\MovieList;
use App\Models\Review;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

// Test endpoint like pada review dan list.
class LikeTest extends TestCase
{
    use RefreshDatabase;

    public function test_like_review(): void
    {
        $review = Review::factory()->create();
        Sanctum::actingAs(User::factory()->create());

        $response = $this->postJson('/api/likes', [
            'likeable_id' => $review->id,
            'likeable_type' => Review::class,
        ]);

        $response->assertStatus(201)->assertJsonPath('data.liked', true);
        $this->assertDatabaseHas('likes', [
            'likeable_id' => $review->id,
            'likeable_type' => Review::class,
        ]);
    }

    public function test_like_list(): void
    {
        $list = MovieList::factory()->create();
        Sanctum::actingAs(User::factory()->create());

        $response = $this->postJson('/api/likes', [
            'likeable_id' => $list->id,
            'likeable_type' => MovieList::class,
        ]);

        $response->assertStatus(201)->assertJsonPath('data.liked', true);
    }

    public function test_like_duplikat(): void
    {
        $review = Review::factory()->create();
        $user = User::factory()->create();
        Sanctum::actingAs($user);
        Like::factory()->create([
            'user_id' => $user->id,
            'likeable_id' => $review->id,
            'likeable_type' => Review::class,
        ]);

        $response = $this->postJson('/api/likes', [
            'likeable_id' => $review->id,
            'likeable_type' => Review::class,
        ]);

        $response->assertStatus(409);
    }

    public function test_unlike_review(): void
    {
        $user = User::factory()->create();
        $review = Review::factory()->create();
        Sanctum::actingAs($user);
        Like::factory()->create([
            'user_id' => $user->id,
            'likeable_id' => $review->id,
            'likeable_type' => Review::class,
        ]);

        $response = $this->deleteJson('/api/likes', [
            'likeable_id' => $review->id,
            'likeable_type' => Review::class,
        ]);

        $response->assertStatus(200)->assertJsonPath('data.liked', false);
    }

    public function test_like_type_tidak_valid(): void
    {
        Sanctum::actingAs(User::factory()->create());

        $response = $this->postJson('/api/likes', [
            'likeable_id' => 1,
            'likeable_type' => 'App\Models\Tag',
        ]);

        $response->assertStatus(422);
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
