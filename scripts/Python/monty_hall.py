import random
from random import seed, randint
import numpy

def juego(puerta_ganadora, puerta_seleccionada, cambio = False):
	assert puerta_ganadora < 3
	assert puerta_ganadora >= 0

	# Chabelo quita la puerta que no seleccionamos
	puerta_descartada = next(i for i in range(3) if i != puerta_seleccionada and i != puerta_ganadora)

	# El jugador decide cambiar
	if cambio:
		puerta_seleccionada = next(i for i in range(3) if i != puerta_seleccionada and i != puerta_descartada)

	return puerta_seleccionada == puerta_ganadora

if __name__ == '__main__':
	puertas = numpy.random.random_integers(0,2,700)
	
	ganadores = [p for p in puertas if juego(1, p)]
	#print(ganadores)
	print("Porcentaje de ganadores sin cambio: " + str(len(ganadores)/len(puertas)) )

	ganadores = [p for p in puertas if juego(1, p, True)]
	print("Porcentaje de ganadores con cambio: " + str(len(ganadores)/len(puertas)) )

