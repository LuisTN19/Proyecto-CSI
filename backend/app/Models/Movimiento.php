<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Movimiento extends Model
{
    protected $table = 'Movimiento';
    
    protected $fillable = [
        'user_id',
        'nombre',
        'cantidad',
        'fecha',
        'esGasto',
    ];

    protected $casts = [
        'cantidad' => 'float',
        'esGasto' => 'boolean',
        'fecha'    => 'date', // Asegura que se maneje como objeto Carbon
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
