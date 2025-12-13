<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Plato extends Model
{
    use HasFactory;

    protected $table = 'Plato'; 
    protected $fillable = [
        'user_id',
        'nombre',
        'descripcion',
        'imagenUrl',
        'ingredientes',
        'tiempo',
        'calorias',
        'estrellas',
        'esFavorito',
    ];

    protected $casts = [
        'ingredientes' => 'array', 
        'esFavorito' => 'boolean',
        'estrellas' => 'double',
    ];
}

