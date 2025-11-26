<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Habito extends Model
{
    protected $fillable = ['nombre', 'completado'];
    protected $casts = [
        'completado' => 'boolean',
    ];
}
