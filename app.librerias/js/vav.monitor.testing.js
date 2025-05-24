//	Iniciar al Cargar
$(function()
{
//	Mover Mesas Almacenadas
	cargarSwich();
});

//	Intervalo de validación de mesa nueva
let votos_timer = null

//	Intervalo de tiempo entre comprobación
const intervalo_votos = 500

//	Listado de mesas en pantalla
const mesas_actuales = []

//	Estado actual del boton
let estado_envio_votos = false;

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Suscribir al Canal PubNub
pubnub.subscribe(
{
	channels: ['vav_mesas'],
//	withPresence: true
});

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Actualizar el listado de mesas
async function cargarSwich()
{
//	Solicitar la mesa asignada
	const api = await fetch( path_app + '/swich/mesas-actuales/' )
	.then( res => res.json() )
	.then( res => res || [] );

	Object.entries(api.mesas).forEach(([key, value]) =>
	{
		mesas_actuales.push(value)
	});
	
	dibujar_mesas();
}

//	Dibujar las mesas en el DOM
function dibujar_mesas()
{
//	Obtener el contenedor de las mesas
	const render = document.getElementById('mesas' );
	render.innerHTML = '';

//	Iterar mesas disponibles
	mesas_actuales.forEach(mesa =>
	{
	//	Crear el div contenedor del candidato
		const objeto = document.createElement('article');

	//	Asignar las propiedades del div
		objeto.id = 'MES' + mesa.id
		objeto.className = `mesa mesa-swich bg-blanco box-shadow bordes-radius filtro-mesa G rojo`
		objeto.setAttribute('mesa', mesa.mesa_id);
		objeto.setAttribute('date', mesa.mesa_cambio);
		objeto.setAttribute('created', mesa.mesa_publicado);

	//	Asignar los elementos al div
		objeto.innerHTML = `<div id="mesa-voto-${mesa.id}" class="cambios bordes-radius"></div>
							<header>
								<h2>
									<i class="fas fa-hashtag"></i> ${mesa.id}
								</h2>
								<div class="tipo">🔴&nbsp;&nbsp;&nbsp;GOBERNADORES</div>
								<div class="zona">${mesa.zona}</div>
								<h3 class="line-1">${mesa.local}</h3>
								<h4 class="line-1">${mesa.numero}</h4>
								<h5 class="line-1" style="padding: 15px 0 22px 0;"><i class="fas fa-globe-americas"></i> ${mesa.comuna}</h5>
							</header>`

	//	Crear candidato en el listado
		render.appendChild(objeto);
	});

//	enviar_votos_iniciar();
}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Enviar votos de prueba
async function enviar_voto()
{
//	Obtener un índice aleatorio
    const mesa_rand = Math.floor(Math.random() * mesas_actuales.length);
	const candidato_rand = Math.floor(Math.random() * mesas_actuales[mesa_rand].candidatos.length);

//	Obtener mesa aleatorea
	const mesa = mesas_actuales[mesa_rand];

//	Obtener candidato aleatorea
	const candidato = mesas_actuales[mesa_rand].candidatos[candidato_rand];
	candidato.votos = candidato.votos + 1;

//	Enviar voto de prueba
    try
	{
    //	Hacer el POST a la API
        const response = await fetch(path_app + '/mesas/voto/', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
            body: `mesa_id=${mesa.id}&voto_id=${candidato.objeto}&voto_total=${candidato.votos}`
        });

    //	Verificar la respuesta
        if (response.ok)
		{
		//	Construir Variable para enviar a PubNub
			const message       	=
			{
				'accion'		:	'voto',
				'accion_voto'   :   's',
				'tipo'          :   'G',
				'mesa'          :	mesa.id,
				'id'            :   candidato.objeto,
				'valor'         :	candidato.votos,
				'candidato'     :   candidato.id
			}

		//	Enviar voto de prueba
			pubnub.publish({
				channel : "vav_mesas",
				message : message
			})

		//	Animar voto en la mesa
			enviar_votos_animacion( mesa.id );

			console.log('VOTO' , candidato.nombres , candidato.apellidos , candidato.votos );
        }
		else
		{
            console.error('Error al enviar el voto:', response.status, response.statusText);
        }
    }
	catch (error)
	{
        console.error('Error de red o en el servidor:', error);
    }
}

//	Enviar voto Iniciador
function enviar_voto_init()
{
	if( estado_envio_votos == false )
	{
		enviar_votos_iniciar();
		estado_envio_votos = true;
	}
	else
	{
		enviar_votos_detener();
		estado_envio_votos = false;
	}
}

//	Iniciar intervalo de actualización de los totales
function enviar_votos_iniciar()
{
//	Enviar votos de prueba
	enviar_voto();

//	Validar si el timer esta activo
	if (votos_timer === null)
	{
		votos_timer = setInterval( enviar_voto , intervalo_votos);
	}

//	Buscar icono en el DOM
	const boton_icono = document.getElementById('test-votos-boton');
	boton_icono.classList.remove('fa-play-circle')
	boton_icono.classList.add('fa-stop-circle')

//	Buscar estado en el DOM
	const estado_envio = document.getElementById('test-votos-estado');
	estado_envio.innerHTML = 'Activado'
}

//	Detener intervalo de actualización de los totales
function enviar_votos_detener()
{
//	Validar si el timer esta activo
	if (votos_timer !== null)
	{
		clearInterval(votos_timer);
		votos_timer = null;
	}

//	Buscar icono en el DOM
	const boton_icono = document.getElementById('test-votos-boton');
	boton_icono.classList.remove('fa-stop-circle')
	boton_icono.classList.add('fa-play-circle')

//	Buscar estado en el DOM
	const estado_envio = document.getElementById('test-votos-estado');
	estado_envio.innerHTML = 'Detenido'
}

//	Animar voto en la mesa
function enviar_votos_animacion(mesa_id)
{
//	Buscar mesa en el DOM
	const mesa_voto = document.getElementById('mesa-voto-' + mesa_id);

//	Validar que exista el elemento
	if( mesa_voto == null )
	{
		return
	}
	else
	{
	//	Asignar clase con la animación
		mesa_voto.classList.add('animacionVotoMesa');

	//	Esperar que la animación termine
		mesa_voto.addEventListener('animationend' , function()
		{
		//	Eliminar la animación
			mesa_voto.classList.remove('animacionVotoMesa');
		});
	}
}