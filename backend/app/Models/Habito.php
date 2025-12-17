<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Habito extends Model
{
    protected $table = 'Habito'; 
    protected $fillable = [ //lo q permito q se rellene desde fuera, proteger la aplicación contra vulnerabilidades de asignación Masiva
        'nombre', 
        'esCompletado', 
        'user_id'   //pq el controlador teine que rellenarlo
    ];
    protected $casts = [    //covertir automaticamente el dato de la variable al tipo con elq ue vamos a trabajar en php
        'esCompletado' => 'boolean',
    ];


    //Un Usuario puede tener muchos habitos asociados
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
