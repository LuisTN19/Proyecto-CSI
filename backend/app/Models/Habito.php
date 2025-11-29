<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Habito extends Model
{
    protected $fillable = [
        'nombre', 
        'completado', 
        'user_id'
    ];
    protected $casts = [
        'completado' => 'boolean',
    ];
}
