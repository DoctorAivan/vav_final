
const set_cache = 'v=3.0.0'

//	URL del diccionario de zonas
	const path_app_zonas = path_app + '/app.librerias/zonas.json?' + set_cache;

//	Mode de la Aplicación
	let app_modo = 0

//	Template de Mesas
	let app_template = 0
	let app_template_historico = 0

//	Diccionario
	let objeto_regiones
	let objeto_provincias
	let objeto_comunas
	let objeto_circunscripciones
	let objeto_distritos
	let objeto_pactos
	let objeto_partidos

//	Estructura de las mesas
	let mesa_1 = null
	let mesa_1_candidatos = null
	let mesa_1_historico = 0
	let switch_mesa_1 = 0
	let switch_mesa_1_anterior = 0

	let mesa_2 = null
	let mesa_2_candidatos = null
	let mesa_2_historico = 0
	let switch_mesa_2 = 0
	let switch_mesa_2_anterior = 0

	let mesa_3 = null
	let mesa_3_candidatos = null
	let mesa_3_historico = 0
	let switch_mesa_3 = 0
	let switch_mesa_3_anterior = 0

	let mesa_4 = null
	let mesa_4_candidatos = null
	let mesa_4_historico = 0
	let switch_mesa_4 = 0
	let switch_mesa_4_anterior = 0

//	Estructura de consolidados
	let mesa_totales_candidatos = null
	let mesa_totales_mesas = 0
	let mesa_totales_votos = 0
	let mesa_totales_estado = false
	let mesa_totales_iniciado = false
	let mesa_totales_tipo = ''
	let mesa_totales_posicion = ''
	let mesa_totales_cantidad = ''
	let mesa_totales_zona = 0
	let mesa_totales_timer = null
	let mesa_totales_preview = false

//	Cantidad maxima de candidatos por listado
	const cantidad_maxima_candidatos = 8

//	Intervalo de actualización de consolidados
	const mesa_totales_intervalo = 6000

//	Transiciones
	const tiempo_transiciones = 600
	const tiempo_transiciones_adicional = 1000

//	-			-			-			-			-			-			-			-			-			-			-			-			

//	URL del repositorio de las imagenes
	const path_imagenes = path_app + '/app.imagenes/'
	const path_imagenes_candidatos = path_imagenes + 'candidatos/'
	const path_imagenes_candidatos_error = path_imagenes + 'candidatos/000.webp?v=2.6'

//	-			-			-			-			-			-			-			-			-			-			-			-			

//	Render de la aplicación en el DOM
	const render = document.getElementById("render")

//	Render de las mesas en el DOM
	const render_mesa_1 = document.getElementById("render-mesa-1")
	const render_mesa_2 = document.getElementById("render-mesa-2")
	const render_mesa_3 = document.getElementById("render-mesa-3")
	const render_mesa_4 = document.getElementById("render-mesa-4")
	const render_mesa_totales = document.getElementById("render-mesa-totales")

//	-			-			-			-			-			-			-			-			-			-			-			-			

//	Contenedor de pantalla Full HD
	const contenedor_tv_ancho = 1920;
	const contenedor_tv_alto = 1080;

//	Contenedor de los candidatos
	const candidato_contenedor_ancho = 450;
	const candidato_contenedor_separacion_x = 255;
	const candidato_contenedor_separacion_y = 657;
	const candidato_contenedor_separacion_y_2 = 216;

//	Cordenadas de la Mesa 1
	const mesa_1_cordenadas = {
		'template_tottem' : {
			'visible' : {
				'x' : candidato_contenedor_separacion_x + 'px',
				'y' : candidato_contenedor_separacion_y + 'px',
				'z' : 'unset'
			},
			'oculta' : {
				'x' : ( candidato_contenedor_ancho * -1) + 'px',
				'y' : candidato_contenedor_separacion_y + 'px',
				'z' : 'unset'
			}
		}
	}

//	Cordenadas de la Mesa 2
	const mesa_2_cordenadas = {
		'template_tottem' : {
			'visible' : {
				'x' : ( contenedor_tv_ancho - candidato_contenedor_ancho - candidato_contenedor_separacion_x ) + 'px',
				'y' : candidato_contenedor_separacion_y + 'px',
				'z' : 'unset'
			},
			'oculta' : {
				'x' : contenedor_tv_ancho + 'px',
				'y' : candidato_contenedor_separacion_y + 'px',
				'z' : 'unset'
			}
		}
	}

//	Cordenadas de la Mesa 3
	const mesa_3_cordenadas = {
		'template_tottem' : {
			'visible' : {
				'x' : candidato_contenedor_separacion_x + 'px',
				'y' : candidato_contenedor_separacion_y_2 + 'px',
				'z' : 'unset'
			},
			'oculta' : {
				'x' : ( candidato_contenedor_ancho * -1) + 'px',
				'y' : candidato_contenedor_separacion_y_2 + 'px',
				'z' : 'unset'
			}
		}
	}

//	Cordenadas de la Mesa 4
	const mesa_4_cordenadas = {
		'template_tottem' : {
			'visible' : {
				'x' : ( contenedor_tv_ancho - candidato_contenedor_ancho - candidato_contenedor_separacion_x ) + 'px',
				'y' : candidato_contenedor_separacion_y_2 + 'px',
				'z' : 'unset'
			},
			'oculta' : {
				'x' : contenedor_tv_ancho + 'px',
				'y' : candidato_contenedor_separacion_y_2 + 'px',
				'z' : 'unset'
			}
		}
	}

//	Cordenadas de la Mesa Totales
	const mesa_totales_cordenadas = {
		'template_tottem' : {
			'visible' : {
				'x' : '0px',
				'y' : '885px',
				'z' : 'unset'
			},
			'oculta' : {
				'x' : '0px',
				'y' : '1150px',
				'z' : 'unset'
			}
		}
	}

//	-			-			-			-			-			-			-			-			-			-			-			-			

//	Iniciar PubNub
	pubnub.addListener(
	{
	//	Recibir Mensajes
		message: function(message)
		{
		//	Obtener Nuevo Dato
			const datoPubNub			=	message.message;

		//	Obtener Accion desde PubNub
			const accion				=	datoPubNub.accion;

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

			console.log( datoPubNub );

		//	Accion : Cambio de switch
			if( accion == 'switch_preview' )
			{
			//	Asignar los ID de las Mesas enviadas
				switch_mesa_1 = datoPubNub.mesa_1
				switch_mesa_2 = datoPubNub.mesa_2
				switch_mesa_3 = datoPubNub.mesa_3
				switch_mesa_4 = datoPubNub.mesa_4

			//	Validar que exista cambio de template
				if( app_modo == datoPubNub.modo )
				{
				//	Validar que la mesa 1 sea distinta a la actual
					if( switch_mesa_1 != switch_mesa_1_anterior || datoPubNub.template == 0 )
					{
						App.animar_salida_mesa_1( datoPubNub.template , datoPubNub.modo , datoPubNub.mesa_1 )
					}

				//	Validar que la mesa 2 sea distinta a la actual
					if( switch_mesa_2 != switch_mesa_2_anterior || datoPubNub.template < 2 )
					{
						App.animar_salida_mesa_2( datoPubNub.template , datoPubNub.modo , datoPubNub.mesa_2 )
					}

				//	Validar que la mesa 3 sea distinta a la actual
					if( switch_mesa_3 != switch_mesa_3_anterior || datoPubNub.template < 3 )
					{
						App.animar_salida_mesa_3( datoPubNub.template , datoPubNub.modo , datoPubNub.mesa_3 )
					}

					console.log('IF');

				//	Validar que la mesa 4 sea distinta a la actual
					if( switch_mesa_4 != switch_mesa_4_anterior || datoPubNub.template < 4 )
					{
						App.animar_salida_mesa_4( datoPubNub.template , datoPubNub.modo , datoPubNub.mesa_4 )
					}

				//	Dibujar mesas en la escena
					setTimeout(function()
					{
					//	Iniciar Animaciones
						App.init();
					}, tiempo_transiciones );
				}
				else
				{
					console.log('ELSE');

				//	Reiniciar ID Historicos
					mesa_1_historico = 0
					mesa_2_historico = 0
					mesa_3_historico = 0
					mesa_4_historico = 0

				//	Animar la salida del bloque
					App.animar_salida_mesa_1( datoPubNub.template , datoPubNub.modo , datoPubNub.mesa_1 )
					App.animar_salida_mesa_2( datoPubNub.template , datoPubNub.modo , datoPubNub.mesa_2 )
					App.animar_salida_mesa_3( datoPubNub.template , datoPubNub.modo , datoPubNub.mesa_3 )
					App.animar_salida_mesa_4( datoPubNub.template , datoPubNub.modo , datoPubNub.mesa_4 )

				//	Dibujar mesas en la escena
					setTimeout(function()
					{
					//	Iniciar Animaciones
						App.init();
					}, tiempo_transiciones );

				//	Almacenar el Template actual
					app_modo = datoPubNub.modo
				}

			//	Almacenar el Template actual
				app_template = datoPubNub.template
			}

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Accion : Voto Emitido
			if( accion == 'voto' )
			{
			//	Variables necesarias
				const id = datoPubNub.id
				const voto = datoPubNub.valor
				const mesa = datoPubNub.mesa
				const candidato = datoPubNub.candidato

			//	Validar que el voto emitido este en pantalla
				App.voto( id , mesa , candidato , voto );
			}

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

			//	Accion : Estado consolidados
			if( accion == 'consolidados_preview' )
			{
			//	Cantidad de candidatos
				mesa_totales_cantidad = datoPubNub.position

			//	Validar estado del Modulo
				if( mesa_totales_preview == false )
				{
					App.totales();

					mesa_totales_preview = true
				}
				else
				{
				//	Detener el Intervalo de actualización
					App.totales_actualizacion_detener();

				//	Iniciar animación de salida
					App.animar_salida_totales();

				//	Actualizar el valor
					mesa_totales_estado = false
					mesa_totales_preview = false
				}
			}

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

			//	Accion : Consolidados template
			if( accion == 'cons_template' )
			{
			//	Cantidad de candidatos
				mesa_totales_cantidad = datoPubNub.position;

			//	Validar que consolidados este activo
				if( mesa_totales_estado )
				{
					App.totales_draw();
				}
			}
		}
	});

//	Suscribirse al Canal
	pubnub.subscribe(
	{
		channels: ['vav_mesas'],
	//	withPresence: true
	});

//	-			-			-			-			-			-			-			-			-			-			-			-			

//	Constructor de la Aplicación
	const App =
	{
	//	Iniciar intervalo de actualización de los totales
		totales_actualizacion_iniciar : () =>
		{
			if (mesa_totales_timer === null)
			{
				mesa_totales_timer = setInterval(App.totales_actualizar, mesa_totales_intervalo);
			}
		},

	//	Detener intervalo de actualización de los totales
		totales_actualizacion_detener : () =>
		{
			if (mesa_totales_timer !== null)
			{
				clearInterval(mesa_totales_timer);
				mesa_totales_timer = null;
			}
		},

	//	Generar interpolación entre el valor actual y final
		totales_actualizacion_votos : (element, newValue, duration) =>
		{
		//	Obtener del DOM el valor actual
			const startValue = Number(element.innerText.replace(',','.'));
			const newValueFormated = Number(newValue);
		
		//	Validar cambio en los votos
			if( startValue === newValueFormated )
			{
				return
			}
			else
			{
				const increment = newValue - startValue;
				const startTime = performance.now();
			
				function update(currentTime)
				{
					const elapsedTime = currentTime - startTime;
					const progress = Math.min(elapsedTime / duration, 1);
					const currentValue = startValue + increment * progress;

					element.textContent = currentValue.toFixed(2).replace('.',',');
					
					if (progress < 1)
					{
						requestAnimationFrame(update);
					}
					else
					{
						element.textContent = currentValue.toFixed(2).replace('.',',');
						return
					}
				}
			
				requestAnimationFrame(update);
			}
		},

	//	Generar interpolación entre el valor actual y final
		totales_actualizacion_votos_totales : (element, newValue, duration) =>
		{
		//	Obtener del DOM el valor actual
			const startValue = Number(element.innerText.replace('.',''));
			const newValueFormated = Number(newValue);
		
		//	Validar cambio en los votos
			if( startValue === newValueFormated )
			{
				return
			}
			else
			{
				const increment = newValue - startValue;
				const startTime = performance.now();
			
				function update(currentTime)
				{
					const elapsedTime = currentTime - startTime;
					const progress = Math.min(elapsedTime / duration, 1);
					const currentValue = startValue + increment * progress;

					element.textContent = App.numero(currentValue.toFixed(0))
					
					if (progress < 1)
					{
						requestAnimationFrame(update);
					}
					else
					{
						element.textContent = App.numero(currentValue.toFixed(0))
						return
					}
				}
			
				requestAnimationFrame(update);
			}
		},

	//	-			-			-			-			-			-			-			-			-			-			-			-			

	//	Mesa con resultados totales
		totales : async function( tipo , zona )
		{
			mesa_totales_tipo = tipo
			mesa_totales_zona = zona

		//	Solicitar la mesa asignada
			const api = await fetch( path_app + '/swich/consolidados-presidencial/' )
			.then( res => res.json() )
			.then( res => res || [] );

			mesa_totales_mesas = api.mesas
			mesa_totales_votos = api.votos

		//	Almacenar listado de candidatos para gestionar actualizacion
			mesa_totales_candidatos = api.candidatos

		//	Validar que existan mesas en la Zona
			if( api.mesas > 0 )
			{
			//	Dibujar la mesa en el DOM
				App.totales_draw();

			//	Actualizar estado
				mesa_totales_estado = true
			}
		},

	//	Actualizar Mesa con resultados totales
		totales_actualizar : async function()
		{
		//	Solicitar la mesa asignada
			const api = await fetch( path_app + '/swich/consolidados-presidencial/' )
			.then( res => res.json() )
			.then( res => res || [] );

			mesa_totales_mesas = api.mesas
			mesa_totales_votos = api.votos

		//	Almacenar listado de candidatos para gestionar actualizacion
			mesa_totales_candidatos = api.candidatos

		//	const get_mesa_totales_votos = document.getElementById('mesa-0-totales');
		//	App.totales_actualizacion_votos_totales(get_mesa_totales_votos , mesa_totales_votos , 1000 );

		//	Validar que existan mesas en la Zona
			if( api.mesas > 0 )
			{
				if( mesa_totales_estado )
				{
					App.ordenar_votos_totales();
				}
			}
		},

	//	Ordenar Votos de los candidatos
		ordenar_votos_totales : function ()
		{
		//	Iterar listado de candidatos
			mesa_totales_candidatos.forEach(candidato =>
			{
			//	Obtener valor del voto
				const candidato_ancho = document.getElementById(`candidato-${candidato.id}`);
				candidato_ancho.style.width = App.validar_porcentaje(candidato.porcentaje) + '%';

			//	Obtener y escribir el total de votos
			//	const candidato_voto_totales = document.getElementById(`candidato-${candidato.id}-totales`);
			//	candidato_voto_totales.textContent = App.numero(candidato.votos);

			//	Obtener el contenedor de porcentaje
				const candidato_voto_valor = document.getElementById(`candidato-${candidato.id}-votos`);

			//	Animar votos
				App.totales_actualizacion_votos(candidato_voto_valor , candidato.porcentaje , 1000 );
			});
		},

	//	Dibujar la mesa en el DOM
		totales_draw : function()
		{
		//  DIV render en el DOM
			const render = document.getElementById('render-mesa-totales' );

		//	Vaciar el contenedor
			render.innerHTML = '';

		//	Crear el DIV de la mesa
			const div_mesa = document.createElement('div');
			div_mesa.id = 'mesa-0'

		//	Asignar las clases a la mesa
			div_mesa.className = `consolidados`

/*
										<span class="totales" id="mesa-0-totales">
											${ App.numero(mesa_totales_votos) }
										</span>
										<span class="subtitulo">VOTOS</span>
*/

		//	Crear elementos en el DIV
			div_mesa.innerHTML =   `<div class="candidatos" id="mesa-0-candidatos"></div>
									<div class="votos-totales">
										<span class="titulo">TENDENCIA EN MESAS PREDICTORAS</span>
									</div>`;

		//	Dibujar la Mesa en el DOM
			render.appendChild(div_mesa);

		//	Render de los candidatos en la mesa
			const render_candidatos = document.getElementById('mesa-0-candidatos');

		//	Ordenar Candidatos por sus votos
			mesa_totales_candidatos.sort((a, b) => (b.votos > a.votos) ? 1 : (b.votos === a.votos) ? ((a.orden > b.orden) ? 1 : -1) : -1 )

		//	Recorrer el listado de candidatos
			mesa_totales_candidatos.forEach(candidato =>
			{
			//	Crear el div contenedor del candidato
				const objeto = document.createElement('div');
				objeto.className = `candidato template-${candidato.orden}`;
				objeto.style.width = App.validar_porcentaje(candidato.porcentaje) + '%';

			//	Asignar las propiedades del div
				objeto.id = 'candidato-' + candidato.id

/*
											Total de votos del candidato
											<span class="totales" id="candidato-${candidato.id}-totales">
												${App.numero(candidato.votos)}
											</span>
											<span class="decorador">VOTOS</span>
*/

			//	Asignar los elementos al div
				objeto.innerHTML = `<div class="up">
										<div class="votos">
											${candidato.nombres}
										</div>
									</div>
									<div class="down">
										<div class="nombre">
											${candidato.apellidos}
										</div>
										<div class="imagen">
											<img class="candidato-imagen-src" src="${path_imagenes_candidatos}${candidato.id}_c.webp?${set_cache}" />
										</div>
										<div class="porcentaje">
											<span class="valor" id="candidato-${candidato.id}-votos">${candidato.porcentaje.replace('.',',')}</span><span class="decorador">%</span>
										</div>
										<div class="estrella">
											<img src="${path_imagenes}star_${candidato.orden == 1 ? 'a' : 'b'}.png" />
										</div>
									</div>`

			//	Crear candidato en el listado
				render_candidatos.appendChild(objeto);

			});

		//	Mostrar el pantalla
			App.animar_entrada_totales();
		},

	//	Animar la entrada del bloque
		animar_entrada_totales : function()	
		{
		//	Asignar Posiciones en el eje X
			render_mesa_totales.style.top = mesa_totales_cordenadas.template_tottem.visible.y;
			render_mesa_totales.style.left = mesa_totales_cordenadas.template_tottem.visible.x;

		//	Iniciar el intervalo de actualización
			App.totales_actualizacion_iniciar();
			
		//	Set estado del total
			mesa_totales_estado = true;
		},

	//	Animar la entrada del bloque
		animar_salida_totales : function()
		{
		//	Asignar Posiciones en el eje X
			render_mesa_totales.style.top = mesa_totales_cordenadas.template_tottem.oculta.y;
			render_mesa_totales.style.left = mesa_totales_cordenadas.template_tottem.oculta.x;

		//	Definir estado de totales
			mesa_totales_estado = false;
		},

	//	-			-			-			-			-			-			-			-			-			-			-			-			

	//	Crear diccionarios
		zone : async function()
		{
		//	Solicitar la mesa asignada
			const api = await fetch( path_app_zonas )
			.then( res => res.json() )
			.then( res => res || [] );

		//	Generar diccionario
			objeto_regiones = api.regiones
			objeto_provincias = api.provincias
			objeto_comunas = api.comunas
			objeto_circunscripciones = api.circunscripciones
			objeto_distritos = api.distritos
			objeto_pactos = api.pactos
			objeto_partidos = api.partidos
		},

	//	Iniciar la App
		init : async function()
		{
		//	Solicitar la mesa asignada
			const api = await fetch( path_app + '/swich/mesas-actuales/' )
			.then( res => res.json() )
			.then( res => res.mesas || [] );

		//	-		-		-		-		-		-		-		-		-		-		-

		//	Validar que exista la Mesa 1
			if( switch_mesa_1 != null )
			{
			//	Obtener la primera mesa
				mesa_1 = api[switch_mesa_1];

				//	Validar Rendereo de la mesa con Historicos
				if( mesa_1_historico != mesa_1.id || app_template_historico != app_template )
				{
				//	Obtener los candidatos de la mesa
					mesa_1_candidatos = mesa_1.candidatos;

				//	Dibujar la mesa en el DOM		
					App.draw( 1 , mesa_1 );
				}
			}

		//	Validar que exista la Mesa 2
			if( switch_mesa_2 != null )
			{
			//	Obtener la primera mesa
				mesa_2 = api[switch_mesa_2];

				//	Validar Rendereo de la mesa con Historicos
				if( mesa_2_historico != mesa_2.id || app_template_historico != app_template )
				{
				//	Obtener los candidatos de la mesa
					mesa_2_candidatos = mesa_2.candidatos;

				//	Dibujar la mesa en el DOM		
					App.draw( 2 , mesa_2 );
				}
			}

		//	Validar que exista la Mesa 3
			if( switch_mesa_3 != null )
			{
			//	Obtener la primera mesa
				mesa_3 = api[switch_mesa_3];

				//	Validar Rendereo de la mesa con Historicos
				if( mesa_3_historico != mesa_3.id || app_template_historico != app_template )
				{
				//	Obtener los candidatos de la mesa
					mesa_3_candidatos = mesa_3.candidatos;

				//	Dibujar la mesa en el DOM		
					App.draw( 3 , mesa_3 );
				}
			}

		//	Validar que exista la Mesa 4
			if( switch_mesa_4 != null )
			{
			//	Obtener la primera mesa
				mesa_4 = api[switch_mesa_4];

				//	Validar Rendereo de la mesa con Historicos
				if( mesa_4_historico != mesa_4.id || app_template_historico != app_template )
				{
				//	Obtener los candidatos de la mesa
					mesa_4_candidatos = mesa_4.candidatos;

				//	Dibujar la mesa en el DOM		
					App.draw( 4 , mesa_4 );
				}
			}

		//	-		-		-		-		-		-		-		-		-		-		-

		//	Almacenar ID Historico de la Mesa 1
			if( api[switch_mesa_1] )
			{
				mesa_1_historico = api[switch_mesa_1].id
			}

		//	Almacenar ID Historico de la Mesa 2
			if( api[switch_mesa_2] )
			{
				mesa_2_historico = api[switch_mesa_2].id
			}

		//	Almacenar ID Historico de la Mesa 3
			if( api[switch_mesa_3] )
			{
				mesa_3_historico = api[switch_mesa_3].id
			}

		//	Almacenar ID Historico de la Mesa 4
			if( api[switch_mesa_4] )
			{
				mesa_4_historico = api[switch_mesa_4].id
			}

		//	-		-		-		-		-		-		-		-		-		-		-

		//	Almacenar Template
			app_template_historico = app_template
		},

	//	Dibujar la mesa en el DOM
		draw : function( posicion , mesa )
		{
        //  DIV render en el DOM
            const render	=	document.getElementById('render-mesa-' + posicion );

		//	Vaciar el contenedor
			render.innerHTML = '';

		//	Crear el DIV de la mesa
			const div_mesa = document.createElement('div');
			div_mesa.id = 'mesa-' + mesa.id

		//	Asignar las clases a la mesa
			div_mesa.className = `box`

		//	Crear elementos en el DIV
			div_mesa.innerHTML =   `<div class="titulo">
										<div class="titulo-numero">
											${mesa.comuna} <span>${mesa.numero}</span>
										</div>
									</div>
									<div class="candidatos" id="mesa-${mesa.id}-candidatos"></div>`;

        //	Dibujar la Mesa en el DOM
			render.appendChild(div_mesa);

		//	Render de los candidatos en la mesa
			const render_candidatos = document.getElementById('mesa-' + mesa.id + '-candidatos');

        //	Recorrer el listado de candidatos
			mesa.candidatos.forEach(candidato =>
            {
            //	Crear el div contenedor del candidato
                const objeto = document.createElement('div');
				objeto.className = `candidato template-${candidato.orden}`

            //	Asignar las propiedades del div
                objeto.id = 'candidato-' + candidato.objeto

			//	Asignar los elementos al div
				objeto.innerHTML = `<div class="imagen">
										<img src="${path_imagenes_candidatos}${candidato.id}.webp?${set_cache}" />
									</div>
									<div class="votos" id="candidato-${candidato.objeto}-votos">
										${candidato.votos}
									</div>
									<div class="candidato-votos-animacion" id="candidato-${candidato.objeto}-animacion"></div>`

            //	Crear candidato en el listado
				render_candidatos.appendChild(objeto);
            });

		//	Asignar posición 2 en pantalla
			if( posicion == 1 )
			{
				if( app_template >= 1 )
				{
					App.animar_entrada_mesa_1();
				}
			}

		//	Asignar posición 2 en pantalla
			if( posicion == 2 )
			{
				if( app_template >= 2 )
				{
					App.animar_entrada_mesa_2();
				}
			}

		//	Asignar posición 3 en pantalla
			if( posicion == 3 )
			{
				if( app_template >= 3 )
				{
					App.animar_entrada_mesa_3();
				}
			}

		//	Asignar posición 4 en pantalla
			if( posicion == 4 )
			{
				if( app_template >= 4 )
				{
					App.animar_entrada_mesa_4();
				}
			}
		},

	//	Asignar votos a un candidato
		voto : function( id , mesa, candidato, votos )
		{
		//	Buscar en candidato en el DOM
			const candidato_votos = document.getElementById(`candidato-${id}-votos`);

		//	Validar que exista el elemento
			if( candidato_votos == null )
			{
				return
			}
			else
			{
			//	Actualizar los votos
				candidato_votos.textContent = votos;

			//	Obtener el contenedor de la animación
				const candidato_animacion = document.getElementById(`candidato-${id}-animacion`);
				candidato_animacion.classList.add('animar_voto');

			//	Esperar que la animación termine
				candidato_animacion.addEventListener('animationend', () => 
					candidato_animacion.classList.remove('animar_voto'), { once: true }
				);
			}
		},

	//			-			-			-			-			-			-			-			-			-			-			-

	//	Animar la entrada del bloque
		animar_entrada_mesa_1 : function()
		{
			render_mesa_1.classList.add('transition-on')

		//	Asignar Posiciones en el eje X
			render_mesa_1.style.bottom = mesa_1_cordenadas.template_tottem.visible.y;
			render_mesa_1.style.left = mesa_1_cordenadas.template_tottem.visible.x;
			render_mesa_1.style.transform = mesa_1_cordenadas.template_tottem.visible.z;
		},

	//	Animar la entrada del bloque
		animar_entrada_mesa_2 : function()
		{
			render_mesa_2.classList.add('transition-on')

		//	Asignar Posiciones en el eje X
			render_mesa_2.style.bottom = mesa_2_cordenadas.template_tottem.visible.y;
			render_mesa_2.style.left = mesa_2_cordenadas.template_tottem.visible.x;
			render_mesa_2.style.transform = mesa_2_cordenadas.template_tottem.visible.z;
		},

	//	Animar la entrada del bloque
		animar_entrada_mesa_3 : function()
		{
			render_mesa_3.classList.add('transition-on')

		//	Asignar Posiciones en el eje X
			render_mesa_3.style.bottom = mesa_3_cordenadas.template_tottem.visible.y;
			render_mesa_3.style.left = mesa_3_cordenadas.template_tottem.visible.x;
			render_mesa_3.style.transform = mesa_3_cordenadas.template_tottem.visible.z;
		},

	//	Animar la entrada del bloque
		animar_entrada_mesa_4 : function()
		{
			render_mesa_4.classList.add('transition-on')

		//	Asignar Posiciones en el eje X
			render_mesa_4.style.bottom = mesa_4_cordenadas.template_tottem.visible.y;
			render_mesa_4.style.left = mesa_4_cordenadas.template_tottem.visible.x;
			render_mesa_4.style.transform = mesa_4_cordenadas.template_tottem.visible.z;
		},

	//			-			-			-			-			-			-			-			-			-			-			-

	//	Animar la entrada del bloque
		animar_salida_mesa_1 : function( template , modo , mesa_id )
		{
		//	Asignar Posiciones en el eje X
			render_mesa_1.style.bottom = mesa_1_cordenadas.template_tottem.oculta.y;
			render_mesa_1.style.left = mesa_1_cordenadas.template_tottem.oculta.x;
			render_mesa_1.style.transform = mesa_1_cordenadas.template_tottem.oculta.z;

		//	Validar que exista un mesa que mostrar
			if( mesa_id != null )
			{
			//	Asignar mesa anterior
				switch_mesa_1_anterior = mesa_id

			//	Reiniciar animación del voto
				setTimeout(function()
				{
				//	Asignar mode del Render
					app_modo = modo;

				}, tiempo_transiciones );
			}
			else
			{
			//	Limpiar mesa
				setTimeout(function()
				{
					if( switch_mesa_1 == null )
					{
					//	Limpiar el Objeto
						mesa_1 = null

					//	Limpiar el DOM
						render_mesa_1.innerHTML = ''
					}

				}, tiempo_transiciones );
			}

			mesa_1_historico = 0
		},

	//	Animar la entrada del bloque
		animar_salida_mesa_2 : function( template , modo , mesa_id )
		{
		//	Asignar Posiciones en el eje X
			render_mesa_2.style.bottom = mesa_2_cordenadas.template_tottem.oculta.y;
			render_mesa_2.style.left = mesa_2_cordenadas.template_tottem.oculta.x;
			render_mesa_2.style.transform = mesa_2_cordenadas.template_tottem.oculta.z;

		//	Validar que exista un mesa que mostrar
			if( mesa_id != null )
			{
			//	Asignar mesa anterior
				switch_mesa_2_anterior = mesa_id

			//	Reiniciar animación del voto
				setTimeout(function()
				{
				//	Asignar mode del Render
					app_modo = modo;

				}, tiempo_transiciones );
			}
			else
			{
			//	Limpiar mesa
				setTimeout(function()
				{
					if( switch_mesa_2 == null )
					{
					//	Limpiar el Objeto
						mesa_2 = null

					//	Limpiar el DOM
						render_mesa_2.innerHTML = ''
					}

				}, tiempo_transiciones );
			}

			if( mesa_id == null )
			{
				mesa_2_historico = 0
			}
		},

	//	Animar la entrada del bloque
		animar_salida_mesa_3 : function( template , modo , mesa_id )
		{
		//	Asignar Posiciones en el eje X
			render_mesa_3.style.bottom = mesa_3_cordenadas.template_tottem.oculta.y;
			render_mesa_3.style.left = mesa_3_cordenadas.template_tottem.oculta.x;
			render_mesa_3.style.transform = mesa_3_cordenadas.template_tottem.oculta.z;

		//	Validar que exista un mesa que mostrar
			if( mesa_id != null )
			{
			//	Asignar mesa anterior
				switch_mesa_3_anterior = mesa_id

			//	Reiniciar animación del voto
				setTimeout(function()
				{
				//	Asignar mode del Render
					app_modo = modo;

				}, tiempo_transiciones );
			}
			else
			{
			//	Limpiar mesa
				setTimeout(function()
				{
					if( switch_mesa_3 == null )
					{
					//	Limpiar el Objeto
						mesa_3 = null

					//	Limpiar el DOM
						render_mesa_3.innerHTML = ''
					}

				}, tiempo_transiciones );
			}

			if( mesa_id == null )
			{
				mesa_3_historico = 0
			}
		},

	//	Animar la entrada del bloque
		animar_salida_mesa_4 : function( template , modo , mesa_id )
		{
		//	Asignar Posiciones en el eje X
			render_mesa_4.style.bottom = mesa_4_cordenadas.template_tottem.oculta.y;
			render_mesa_4.style.left = mesa_4_cordenadas.template_tottem.oculta.x;
			render_mesa_4.style.transform = mesa_4_cordenadas.template_tottem.oculta.z;

		//	Validar que exista un mesa que mostrar
			if( mesa_id != null )
			{
			//	Asignar mesa anterior
				switch_mesa_4_anterior = mesa_id

			//	Reiniciar animación del voto
				setTimeout(function()
				{
				//	Asignar mode del Render
					app_modo = modo;

				}, tiempo_transiciones );
			}
			else
			{
			//	Limpiar mesa
				setTimeout(function()
				{
					if( switch_mesa_4 == null )
					{
					//	Limpiar el Objeto
						mesa_4 = null

					//	Limpiar el DOM
						render_mesa_4.innerHTML = ''
					}

				}, tiempo_transiciones );
			}

			if( mesa_id == null )
			{
				mesa_4_historico = 0
			}
		},

	//			-			-			-			-			-			-			-			-			-			-			-

	//	Limite del ancho maximo del contenedor
		validar_porcentaje : function( valor ){

		//	Convertir a entero
			const porcentaje = Number(valor);
			
		//	Validar porcentaje maximo
			if( porcentaje > 65 )
			{
				return 65;
			}
			else
			{
			//	Validar porcentaje minimo
				if( porcentaje < 35 )
				{
					return 35
				}
				else
				{
					return porcentaje;
				}
			}
		},

	//	Agregar miles a los numeros
		numero : function( valor )
		{
			return new Intl.NumberFormat('en-DE').format(valor);
		}

	}

//	Iniciar las Zonas
	App.zone();