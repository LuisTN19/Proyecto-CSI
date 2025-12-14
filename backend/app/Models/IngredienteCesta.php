<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;


class IngredienteCesta extends Model
{
    use HasFactory;
    protected $table = 'IngredienteCesta';

    protected $fillable = [
        'user_id',
        'nombre',
    ];
    
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
