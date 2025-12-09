use std::io;
use std::time::Instant;

static mut NUM_SOLUCIONES: u32 = 0;

/// Verifica si la reina colocada en `fila_actual` es segura.
/// `posiciones` es un vector donde `posiciones[i]` guarda la columna de la reina en la fila `i`.
fn es_seguro(posiciones: &[usize], fila_actual: usize) -> bool {
    for i in 0..fila_actual {
        if posiciones[i] == posiciones[fila_actual]
            || (posiciones[i] as isize - posiciones[fila_actual] as isize).abs()
                == (i as isize - fila_actual as isize).abs()
        {
            return false;
        }
    }
    true
}

/// Función principal de Backtracking para resolver N-Reinas
fn n_reinas(posiciones: &mut Vec<usize>, fila_actual: usize, n: usize) {
    // Caso base: se han colocado N reinas (una en cada fila).
    if fila_actual == n {
        NUM_SOLUCIONES += 1;
        return;
    }

    // Intenta colocar la reina en la "fila_actual" en cada columna.
    for columna in 0..n {
        posiciones[fila_actual] = columna;
        // Verifica si es seguro colocar la reina en "fila_actual" en esta "columna"
        if es_seguro(posiciones, fila_actual) {
            // Si es seguro, pasa a la siguiente fila
            n_reinas(posiciones, fila_actual + 1, n);
        }
    }
}

fn main() {
    let mut input = String::new();
    print!("Introduce el tamaño del tablero (N): ");

    // Forzar el volcado de la salida para que el mensaje se muestre antes de la entrada.
    io::Write::flush(&mut io::stdout()).expect("Error al vaciar stdout");

    // Leer la entrada del usuario.
    io::stdin()
        .read_line(&mut input)
        .expect("Error al leer la línea");

    let n: usize = match input.trim().parse() {
        Ok(num) if num > 0 => num,
        _ => {
            println!("N debe ser un entero positivo.");
            return;
        }
    };

    // Vector para almacenar la posición de la columna de la reina para cada fila.
    let mut posiciones = vec![0; n];
    println!("\nBuscando soluciones para N = {}...", n);

    // --- INICIO de la medición de tiempo ---
    let start_time = Instant::now();

    // Llamada a la función principal.
    n_reinas(&mut posiciones, 0, n);

    // --- FIN de la medición de tiempo ---
    let duration = start_time.elapsed();

    let total_soluciones = unsafe { NUM_SOLUCIONES };

    println!("\n--- Resumen ---");
    println!("Total de soluciones encontradas: {}", total_soluciones);
    let tiempo_ms = duration.as_secs_f64() * 1000.0;
    println!("Tiempo de ejecucion: {:.3} milisegundos\n", tiempo_ms);
}
