<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Movimiento extends Model
{
    protected $table = 'movimientos';
    
    protected $fillable = [
        'user_id',
        'nombre',
        'cantidad',
        'fecha',
        'es_gasto',
    ];

    // Esto asegura que Laravel devuelva la 'cantidad' como float y 'es_gasto' como booleano de forma automática.
    protected $casts = [
        'cantidad' => 'float',
        'es_gasto' => 'boolean',
        'fecha'    => 'date', // Asegura que se maneje como objeto Carbon
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
