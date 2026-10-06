// ignore_for_file: avoid_print
import 'package:flutter/material.dart';

import '../models/videojuego.dart';
import 'etiquetaGenero.dart';

class TarjetaVideojuego extends StatefulWidget {
  final Videojuego juego;

  const TarjetaVideojuego({super.key, required this.juego});

  @override
  State<TarjetaVideojuego> createState() => _TarjetaVideojuegoState();
}

class _TarjetaVideojuegoState extends State<TarjetaVideojuego> {
  static const Color _fondo = Color(0xFF15151F);
  static const Color _verde = Color(0xFF22C55E);
  static const Color _amarillo = Color(0xFFFACC15);

  bool _favorito = false;
  int _enCarrito = 0;

  // ---------- Operación sencilla: precio con descuento ----------
  // Se trunca a céntimos para obtener 19.99 (y no 20.00 por redondeo).
  double get _precioOferta {
    final bruto =
        widget.juego.precioOriginal * (1 - widget.juego.descuento / 100);
    return (bruto * 100).floor() / 100;
  }

  double get _totalCarrito => _precioOferta * _enCarrito;

  // ---------- Acciones ----------

  // IconButton con acción propia: favorito.
  void _alternarFavorito() {
    setState(() => _favorito = !_favorito);
    print(
      _favorito
          ? '${widget.juego.titulo} añadido a favoritos'
          : '${widget.juego.titulo} quitado de favoritos',
    );
  }

  // IconButton con acción propia: carrito (calcula el total).
  void _anadirAlCarrito() {
    setState(() => _enCarrito++);
    print(
      'Carrito: $_enCarrito x \$${_precioOferta.toStringAsFixed(2)} '
      '= \$${_totalCarrito.toStringAsFixed(2)}',
    );
  }

  // Función que recibe un parámetro (plataforma pulsada).
  void _plataformaPulsada(String plataforma) {
    print('Plataforma seleccionada: $plataforma');
  }

  // Función que recibe un parámetro (usada por el GestureDetector de la portada).
  void _portadaPulsada(String titulo) {
    print('Has pulsado la portada de "$titulo"');
  }

  // Función usada directamente como callback (onPressed: _verDetalles).
  void _verDetalles() {
    print(
      'Ver detalles de ${widget.juego.titulo} '
      '(oferta -${widget.juego.descuento}%: \$${_precioOferta.toStringAsFixed(2)})',
    );
  }

  IconData _iconoPlataforma(String p) {
    switch (p) {
      case 'PC':
        return Icons.desktop_windows_outlined;
      case 'PS4':
        return Icons.sports_esports_outlined;
      default:
        return Icons.gamepad_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final juego = widget.juego;

    return Container(
      width: 360,
      decoration: BoxDecoration(
        color: _fondo,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 30,
            offset: Offset(0, 16),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _portada(juego),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  juego.estudio.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  juego.titulo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [for (final g in juego.generos) Etiqueta(texto: g)],
                ),
                _divisor(),
                _valoracionYLanzamiento(juego),
                const SizedBox(height: 16),
                _plataformas(juego),
                _divisor(),
                _filaPrecio(juego),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Partes de la tarjeta ----------

  Widget _portada(Videojuego juego) {
    return GestureDetector(
      // GestureDetector sobre un elemento que NO es un botón.
      onTap: () => _portadaPulsada(juego.titulo),
      onDoubleTap: () => print('Doble toque en la portada'),
      child: SizedBox(
        height: 220,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(juego.imagen, fit: BoxFit.cover),
            // Degradado inferior para fundir la imagen con la tarjeta.
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, _fondo.withOpacity(0.95)],
                  stops: const [0.5, 1],
                ),
              ),
            ),
            // Insignia de oferta
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _verde.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _verde.withOpacity(0.6)),
                ),
                child: Text(
                  '−${juego.descuento}% OFERTA',
                  style: const TextStyle(
                    color: _verde,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            // Puntuación
            Positioned(
              top: 14,
              right: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      juego.valoracion.toString(),
                      style: const TextStyle(
                        color: _amarillo,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text(
                      'SCORE',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 9,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divisor() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Divider(height: 1, color: Colors.white.withOpacity(0.08)),
  );

  Widget _tituloSeccion(String texto) => Text(
    texto,
    style: const TextStyle(
      color: Colors.white38,
      fontSize: 11,
      letterSpacing: 1.3,
    ),
  );

  Widget _valoracionYLanzamiento(Videojuego juego) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _tituloSeccion('VALORACIÓN'),
              const SizedBox(height: 8),
              Row(
                children: List.generate(
                  5,
                  (_) => const Icon(Icons.star, color: _amarillo, size: 16),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${juego.valoracion} / 10 · ${juego.votos} votos',
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _tituloSeccion('LANZAMIENTO'),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 13,
                    color: Colors.white54,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    juego.lanzamiento,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                juego.distribuidora,
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _plataformas(Videojuego juego) {
    return Row(
      children: [
        _tituloSeccion('PLATAFORMAS'),
        const SizedBox(width: 12),
        for (final p in juego.plataformas)
          Padding(
            padding: const EdgeInsets.only(right: 6),
            // Cada chip es un GestureDetector que llama a una función con parámetro.
            child: GestureDetector(
              onTap: () => _plataformaPulsada(p),
              child: Etiqueta(texto: p, icono: _iconoPlataforma(p)),
            ),
          ),
      ],
    );
  }

  Widget _filaPrecio(Videojuego juego) {
    final estiloIcono = IconButton.styleFrom(
      backgroundColor: Colors.white.withOpacity(0.05),
      side: BorderSide(color: Colors.white.withOpacity(0.12)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      fixedSize: const Size(42, 42),
    );

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '\$${juego.precioOriginal.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 12,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            Text(
              '\$${_precioOferta.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: _alternarFavorito,
          style: estiloIcono,
          icon: Icon(
            _favorito ? Icons.favorite : Icons.favorite_border,
            size: 20,
            color: _favorito ? Colors.redAccent : Colors.white70,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: _anadirAlCarrito,
          style: estiloIcono,
          icon: Badge(
            isLabelVisible: _enCarrito > 0,
            label: Text('$_enCarrito'),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 20,
              color: Colors.white70,
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Botón con onPressed que recibe directamente una función.
        ElevatedButton(
          onPressed: _verDetalles,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2A2A38),
            foregroundColor: Colors.white,
            elevation: 0,
            minimumSize: const Size(0, 42),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.white.withOpacity(0.18)),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Ver detalles', style: TextStyle(fontSize: 13)),
              SizedBox(width: 6),
              Icon(Icons.arrow_forward, size: 14),
            ],
          ),
        ),
      ],
    );
  }
}
