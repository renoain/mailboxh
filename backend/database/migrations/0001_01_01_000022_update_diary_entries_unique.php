<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

// Izinkan entri diary berulang untuk film sama pada tanggal berbeda.
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('diary_entries', function (Blueprint $table): void {
            $table->dropUnique(['user_id', 'movie_id']);
            $table->unique(['user_id', 'movie_id', 'watched_date']);
        });
    }

    public function down(): void
    {
        Schema::table('diary_entries', function (Blueprint $table): void {
            $table->dropUnique(['user_id', 'movie_id', 'watched_date']);
            $table->unique(['user_id', 'movie_id']);
        });
    }
};
