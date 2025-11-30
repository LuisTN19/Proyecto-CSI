<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Evento extends Model
{
    use HasFactory;

    protected $table = 'eventos';
    
    protected $fillable = [
        'titulo',
        'fecha',
        'user_id',
    ];

    // 💡 Indica que el campo 'fecha' debe ser tratado como un objeto Carbon/DateTime.
    // Esto es útil si quieres manipular la fecha en Laravel.
    protected $casts = [
        'fecha' => 'date', 
    ];
}
