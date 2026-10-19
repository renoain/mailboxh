<?php

declare(strict_types=1);

namespace Tests\Feature;

use App\Models\Notification;
use App\Models\Review;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

// Test notifikasi sosial saat review di-like, dikomentari, dan follow.
class NotificationTest extends TestCase
{
    use RefreshDatabase;

    public function test_notifikasi_saat_review_di_like(): void
    {
        $owner = User::factory()->create();
        $actor = User::factory()->create();
        $review = Review::factory()->create(['user_id' => $owner->id]);
        Sanctum::actingAs($actor);

        $this->postJson('/api/likes', [
            'likeable_id' => $review->id,
            'likeable_type' => Review::class,
        ]);

        $this->assertDatabaseHas('notifications', [
            'user_id' => $owner->id,
            'actor_id' => $actor->id,
            'type' => 'like_review',
        ]);
    }

    public function test_notifikasi_saat_komentar(): void
    {
        $owner = User::factory()->create();
        $actor = User::factory()->create();
        $review = Review::factory()->create(['user_id' => $owner->id]);
        Sanctum::actingAs($actor);

        $this->postJson('/api/reviews/'.$review->id.'/comments', ['content' => 'Bagus.']);

        $this->assertDatabaseHas('notifications', [
            'user_id' => $owner->id,
            'actor_id' => $actor->id,
            'type' => 'comment_review',
        ]);
    }

    public function test_notifikasi_saat_di_follow(): void
    {
        $target = User::factory()->create();
        $actor = User::factory()->create();
        Sanctum::actingAs($actor);

        $this->postJson('/api/follow/'.$target->id);

        $this->assertDatabaseHas('notifications', [
            'user_id' => $target->id,
            'actor_id' => $actor->id,
            'type' => 'follow',
        ]);
    }

    public function test_daftar_notifikasi(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user);
        Notification::factory()->create(['user_id' => $user->id]);

        $response = $this->getJson('/api/notifications');

        $response->assertStatus(200)->assertJsonCount(1, 'data');
    }

    public function test_tandai_dibaca(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user);
        $notification = Notification::factory()->create(['user_id' => $user->id]);

        $response = $this->putJson('/api/notifications/'.$notification->id.'/read');

        $response->assertStatus(200);
        $this->assertDatabaseHas('notifications', ['id' => $notification->id, 'is_read' => true]);
    }

    public function test_tandai_semua_dibaca(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user);
        Notification::factory()->count(2)->create(['user_id' => $user->id]);

        $response = $this->putJson('/api/notifications/read-all');

        $response->assertStatus(200);
        $this->assertSame(0, Notification::where('user_id', $user->id)->where('is_read', false)->count());
    }
}
