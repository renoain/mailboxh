<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Notification extends Model
{
    use HasFactory;

    public const string TYPE_LIKE_REVIEW = 'like_review';

    public const string TYPE_COMMENT_REVIEW = 'comment_review';

    public const string TYPE_FOLLOW = 'follow';

    public const string TYPE_LIKE_LIST = 'like_list';

    protected $fillable = ['user_id', 'actor_id', 'type', 'reference_id', 'is_read'];

    protected function casts(): array
    {
        return ['is_read' => 'boolean'];
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function actor()
    {
        return $this->belongsTo(User::class, 'actor_id');
    }
}
