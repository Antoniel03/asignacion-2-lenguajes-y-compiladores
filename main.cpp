#include <iostream>
#include <vector>
#include <cmath>
#include <chrono> // Para medir el tiempo

using namespace std;

static int num_soluciones = 0;

// Verifica si la reina es segura.
bool es_seguro(const vector<int>& posiciones, int k) {
    for (int i = 0; i < k; i++) {
        if (posiciones[i] == posiciones[k] || abs(posiciones[i] - posiciones[k]) == abs(i - k)) {
            return false;
        }
    }
    return true;
}

// Función principal de Backtracking
void n_reinas(vector<int>& posiciones, int fila_actual, int N) {
    if (fila_actual == N) {
        num_soluciones++;
        return;
    }
    for (int columna = 0; columna < N; columna++) {
        posiciones[fila_actual] = columna;
        //Validación de la posición de la reina
        if (es_seguro(posiciones, fila_actual)) {
            //Revisión de la siguiente fila
            n_reinas(posiciones, fila_actual + 1, N);
        }
    }
}

int main() {
    int N;
    cout << "Introduce el tamano del tablero (N): ";
    if (!(cin >> N) || N <= 0) {
        cout << "N debe ser un entero positivo.\n";
        return 1;
    }

    vector<int> posiciones(N);
    cout << "\nBuscando soluciones para N = " << N << "...\n";

    // --- INICIO de la medición de tiempo ---
    auto start_time = chrono::high_resolution_clock::now();

    n_reinas(posiciones, 0, N);

    // --- FIN de la medición de tiempo ---
    auto end_time = chrono::high_resolution_clock::now();

    // Calcular la duración en milisegundos
    auto duration = chrono::duration_cast<chrono::milliseconds>(end_time - start_time);

    cout << "\n--- Resumen ---\n";
    cout << "Total de soluciones encontradas: " << num_soluciones << "\n";
    float time= duration.count();
    cout << "Tiempo de ejecucion: " <<  time << " milisegundos\n";
}
