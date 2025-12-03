<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Plato extends Model
{
    use HasFactory;

    protected $table = 'platos'; 
    protected $fillable = [
        'user_id',
        'nombre',
        'descripcion',
        'imagen_url',
        'ingredientes',
        'tiempo',
        'calorias',
        'calificacion',
        'favorito',
    ];

    protected $casts = [
        'ingredientes' => 'array', 
        'favorito' => 'boolean',
        'calificacion' => 'double',
    ];
}

