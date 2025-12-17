<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Evento extends Model
{
    use HasFactory;

    protected $table = 'Evento';
    protected $fillable = [
        'titulo',
        'fecha',
        'user_id',
    ];

    protected $casts = [
        'fecha' => 'date', //'fecha' debe ser tratado como un objeto Carbon/DateTime.
    ];
}
