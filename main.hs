import Data.Time.Clock (getCurrentTime, diffUTCTime)
import Control.Monad (forM_)
import System.IO (hFlush, stdout)

-- Verifica si una reina es segura
esSeguro :: [Int] -> Int -> Bool
esSeguro posiciones col =
    let fila = length posiciones
    in and [ col /= c && abs (col - c) /= abs (fila - r)
           | (c, r) <- zip posiciones [0..] ]

-- Imprime el tablero
imprimirTablero :: [Int] -> IO ()
imprimirTablero posiciones = do
    putStrLn "\n--- Solución ---"
    let n = length posiciones
    forM_ posiciones $ \col -> do
        let fila = [ if c == col then " Q " else " . " | c <- [0..n-1] ]
        putStrLn (concat fila)

-- Backtracking
nReinas :: Int -> [Int] -> IO Int
nReinas n posiciones
    | length posiciones == n = do
        -- imprimirTablero posiciones
        return 1
    | otherwise = do
        let fila = length posiciones

        resultados <- mapM (\col -> do

                if esSeguro posiciones col
                    then do
                        nReinas n (posiciones ++ [col])
                    else do
                        return 0

            ) [0..n-1]

        return (sum resultados)

main :: IO ()
main = do
    putStr "Introduce el tamaño del tablero (N): "
    hFlush stdout
    entrada <- getLine
    let n = read entrada :: Int

    if n <= 0
        then putStrLn "N debe ser un entero positivo."
        else do
            putStrLn $ "\nBuscando soluciones para N = " ++ show n ++ "..."

            start <- getCurrentTime
            totalSoluciones <- nReinas n []
            end <- getCurrentTime

            let tiempo = realToFrac (diffUTCTime end start) :: Double

            putStrLn "\n--- Resumen ---"
            putStrLn $ "Total de soluciones encontradas: " ++ show totalSoluciones
            putStrLn $ "Tiempo de ejecución: " ++ show (tiempo * 1000) ++ " milisegundos"
