class videojuego {
  final String estudio;
  final String titulo;
  final List<String> generos;
  final List<String> plataformas;
  final double valoracion;
  final String votos;
  final String lanzamiento;
  final String distribuidora;
  final String imagen;
  final double precioOriginal;
  final int descuento;

  const Videojuego({
    required this.estudio,
    required this.titulo,
    required this.generos,
    required this.plataformas,
    required this.valoracion,
    required this.votos,
    required this.lanzamiento,
    required this.distribuidora,
    required this.imagen,
    required this.precioOriginal,
    required this.descuento,
  });
}
