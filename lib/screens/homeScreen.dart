import 'package:flutter/material.dart';

import '../models/videojuego.dart';
import '../widgets/tarjetaVideojuego.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const juego = Videojuego(
      estudio: 'Rocksteady Studios',
      titulo: 'Batman: Arkham Knight',
      generos: ['Acción-Aventura', 'Mundo Abierto', 'Superhéroes'],
      plataformas: ['PC', 'PS4', 'Xbox'],
      valoracion: 9.2,
      votos: '48K',
      lanzamiento: '23 Jun 2015',
      distribuidora: 'WB Games',
      imagen: 'assets/images/batman.jpg',
      precioOriginal: 39.99,
      descuento: 50,
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF0D0D16)],
          ),
        ),
        child: const SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: TarjetaVideojuego(juego: juego),
            ),
          ),
        ),
      ),
    );
  }
}
