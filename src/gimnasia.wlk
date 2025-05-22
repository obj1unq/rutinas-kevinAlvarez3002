class RutinaBase {
  const intensidad
  
  method caloriasQueBaja(tiempo) = (100 * (tiempo - self.tiempoDeDescanso(
    tiempo
  ))) * intensidad
  
  method tiempoDeDescanso(tiempo)
}

class Running inherits RutinaBase {
  override method tiempoDeDescanso(tiempo) = if (tiempo > 20) 5 else 2
}

class Maraton inherits Running {
  override method caloriasQueBaja(tiempo) = super(tiempo) * 2
}

class Remo inherits RutinaBase (intensidad = 1.3) {
  override method tiempoDeDescanso(tiempo) = tiempo / 5
}

class RemoDeCompeticion inherits Remo (intensidad = 1.7) {
  override method tiempoDeDescanso(tiempo) = (super(tiempo) - 3).max(2)
}

class PersonaBase {
  const tiempoQueEjercita
  const kilosPorCaloria
  var property peso
  
  method pesoQuePierdeAlPracticarRutina(rutina) = rutina.caloriasQueBaja(
    tiempoQueEjercita
  ) / kilosPorCaloria
  
  method practicarRutina(rutina) {
    peso = (peso - self.pesoQuePierdeAlPracticarRutina(rutina)).truncate(3)
  }
  
  method caloriasQueBajaria(rutina) = rutina.caloriasQueBaja(tiempoQueEjercita)
}

class PersonaSedentaria inherits PersonaBase (kilosPorCaloria = 7000) {
  override method practicarRutina(rutina) {
    if (peso > 50) {
      super(rutina)
    }
  }
}

class PersonaAtletica inherits PersonaBase (
  kilosPorCaloria = 8000,
  tiempoQueEjercita = 90
) {
  override method practicarRutina(rutina) {
    if (self.caloriasQueBajaria(rutina) > 10000) {
      super(rutina)
    }
  }
  
  override method pesoQuePierdeAlPracticarRutina(rutina) = super(rutina) - 1
}

class Club {
  const property predios = #{}
  
  method mejorPredioParaPersona(persona) = predios.max(
    { predio => predio.caloriasQueGastaria(persona) }
  )
  
  method prediosTranquis(persona) = predios.filter(
    { predio => predio.tieneRutinaTranqui(persona) }
  )
  
  method rutinasMasExigentes(persona) = predios.map(
    { predio => predio.rutinaMasExigente(persona) }
  ).asSet()
}

class Predio {
  const property rutinas = #{}
  
  method caloriasQueGastaria(persona) = rutinas.sum(
    { rutina => persona.pesoQuePierdeAlPracticarRutina(rutina) }
  )
  
  method tieneRutinaTranqui(persona) = rutinas.any(
    { rutina => persona.caloriasQueBajaria(rutina) < 500 }
  ) //faltaria crear un metodo en base a lo del bloque 
  
  method rutinaMasExigente(persona) = rutinas.max(
    { rutina => persona.caloriasQueBajaria(rutina) }
  )
}