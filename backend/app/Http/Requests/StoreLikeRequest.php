<?php

declare(strict_types=1);

namespace App\Http\Requests;

use App\Models\Movie;
use App\Models\MovieList;
use App\Models\Review;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

// Validasi tanda suka pada film, review, atau list.
class StoreLikeRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'likeable_id' => ['required', 'integer'],
            'likeable_type' => ['required', 'string', Rule::in([Movie::class, Review::class, MovieList::class])],
        ];
    }
}
