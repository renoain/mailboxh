<?php

declare(strict_types=1);

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

// Validasi tanda suka pada film.
class StoreLikeRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'movie_id' => ['required', 'integer', 'exists:movies,id'],
        ];
    }
}
