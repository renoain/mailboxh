<?php

declare(strict_types=1);

namespace Tests\Feature;

use App\Models\Comment;
use App\Models\Review;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

// Test komentar pada review.
class CommentTest extends TestCase
{
    use RefreshDatabase;

    public function test_tambah_komentar(): void
    {
        $review = Review::factory()->create();
        Sanctum::actingAs(User::factory()->create());

        $response = $this->postJson('/api/reviews/'.$review->id.'/comments', [
            'content' => 'Setuju.',
        ]);

        $response->assertStatus(201)->assertJsonPath('data.content', 'Setuju.');
        $this->assertDatabaseHas('comments', [
            'review_id' => $review->id,
            'content' => 'Setuju.',
        ]);
    }

    public function test_list_komentar(): void
    {
        $review = Review::factory()->create();
        Comment::factory()->count(2)->create(['review_id' => $review->id]);
        Sanctum::actingAs(User::factory()->create());

        $response = $this->getJson('/api/reviews/'.$review->id.'/comments');

        $response->assertStatus(200)->assertJsonCount(2, 'data');
    }

    public function test_hapus_komentar(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user);
        $comment = Comment::factory()->create(['user_id' => $user->id]);

        $response = $this->deleteJson('/api/comments/'.$comment->id);

        $response->assertStatus(200);
        $this->assertDatabaseMissing('comments', ['id' => $comment->id]);
    }

    public function test_hapus_komentar_bukan_pemilik(): void
    {
        Sanctum::actingAs(User::factory()->create());
        $comment = Comment::factory()->create();

        $response = $this->deleteJson('/api/comments/'.$comment->id);

        $response->assertStatus(403);
    }

    public function test_komentar_content_wajib(): void
    {
        $review = Review::factory()->create();
        Sanctum::actingAs(User::factory()->create());

        $response = $this->postJson('/api/reviews/'.$review->id.'/comments', ['content' => '']);

        $response->assertStatus(422);
    }
}
