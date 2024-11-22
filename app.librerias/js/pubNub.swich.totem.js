//	URL del diccionario de zonas
	const path_app_zonas = path_app + '/app.librerias/zonas.json?v=3.7'

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

//	Estructura de Datos
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

//	Estado Consolidados
	let mesa_totales_candidatos = null
	let mesa_totales_mesas = 0
	let mesa_totales_votos = 0
	let mesa_totales_estado = false
	let mesa_totales_iniciado = false
	let mesa_totales_tipo = ''
	let mesa_totales_posicion = ''
	let mesa_totales_zona = 0
	let mesa_totales_timer = null

//	Intervalo de actualización de consolidados
	const mesa_totales_intervalo = 2500

//	Transiciones
	const tiempo_transiciones = 600
	const tiempo_transiciones_adicional = 1000

//	-			-			-			-			-			-			-			-			-			-			-			-			

//	URL del repositorio de las imagenes
	const path_imagenes = path_app + '/app.imagenes/'
	const path_imagenes_candidatos = path_imagenes + 'candidatos/'
	const path_imagenes_candidatos_error = path_imagenes + 'candidatos/000.webp'

//	-			-			-			-			-			-			-			-			-			-			-			-			

//	Render de la aplicación en el DOM
	const render = document.getElementById("render")

//	Render de las mesas en el DOM
	const render_mesa_1 = document.getElementById("render-mesa-1")
	const render_mesa_2 = document.getElementById("render-mesa-2")
	const render_mesa_totales = document.getElementById("render-mesa-totales")

//	-			-			-			-			-			-			-			-			-			-			-			-			

//	Posicion de los Elementos en las Animaciones

//	Cordenadas de la Mesa 1
	const mesa_1_cordenadas = {
		'template_tottem' : {
			'visible' : {
				'x' : '55px',
				'y' : '178px',
				'z' : 'unset'
			},
			'oculta' : {
				'x' : '-650px',
				'y' : '178px',
				'z' : 'unset'
			}
		},
		'template_floating' : {
			'visible' : {
				'x' : '55px',
				'y' : '178px',
				'z' : 'unset'
			},
			'oculta' : {
				'x' : '-650px',
				'y' : '178px',
				'z' : 'unset'
			}
		}
	}

//	Cordenadas de la Mesa 2
	const mesa_2_cordenadas = {
		'template_tottem' : {
			'visible' : {
				'x' : '1215px',
				'y' : '178px',
				'z' : 'unset'
			},
			'oculta' : {
				'x' : '1920px',
				'y' : '178px',
				'z' : 'unset'
			}
		},
		'template_floating' : {
			'visible' : {
				'x' : '1215px',
				'y' : '178px',
				'z' : 'unset'
			},
			'oculta' : {
				'x' : '1920px',
				'y' : '178px',
				'z' : 'unset'
			}
		}
	}

//	Cordenadas de la Mesa Totales
	const mesa_totales_cordenadas = {
		'template_tottem' : {
			'visible' : {
				'x' : '0px',
				'y' : '0px',
				'z' : 'unset'
			},
			'oculta' : {
				'x' : '-380px',
				'y' : '0px',
				'z' : 'unset'
			}
		},
		'template_floating' : {
			'visible' : {
				'x' : '1540px',
				'y' : '0px',
				'z' : 'unset'
			},
			'oculta' : {
				'x' : '1920px',
				'y' : '0px',
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

		//	Accion : Cambio de switch
			if( accion == 'switch' )
			{
			//	Asignar los ID de las Mesas enviadas
				switch_mesa_1 = datoPubNub.mesa_1
				switch_mesa_2 = datoPubNub.mesa_2

			//	Validar que exista cambio de template
				if( app_modo == datoPubNub.modo )
				{
				//	Validar que la mesa 1 sea distinta a la actual
					if( switch_mesa_1 != switch_mesa_1_anterior || datoPubNub.template == 0 )
					{
						App.animar_salida_mesa_1( datoPubNub.template , datoPubNub.modo , datoPubNub.mesa_1 )
					}
	
				//	Validar que la mesa 2 sea distinta a la actual
					if( switch_mesa_2 != switch_mesa_2_anterior || app_template != datoPubNub.template )
					{
						App.animar_salida_mesa_2( datoPubNub.template , datoPubNub.modo , datoPubNub.mesa_2 )
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
				//	Reiniciar ID Historicos
					mesa_1_historico = 0
					mesa_2_historico = 0

				//	Animar la salida del bloque
					App.animar_salida_mesa_1( datoPubNub.template , datoPubNub.modo , datoPubNub.mesa_1 )
					App.animar_salida_mesa_2( datoPubNub.template , datoPubNub.modo , datoPubNub.mesa_2 )

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
				const accion_voto = datoPubNub.accion_voto

			//	Validar que el voto emitido este en pantalla
				App.voto( id , mesa , candidato , voto );

			//	Sumer votos a la mesa de consolidados
			//	App.voto_totales( candidato , voto , accion_voto );
			}

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

			//	Accion : Estado consolidados
			if( accion == 'cons_estado' )
			{
			//	Variables necesarias
				const estado = datoPubNub.estado

			//	Validar estado del Modulo
				if( estado == 'on' )
				{
				//	Obtener detalles de la Zona
					const mesa_tipo = datoPubNub.tipo;
					const mesa_zona = datoPubNub.zona;

				//	Posicion de la mesa
					mesa_totales_posicion = datoPubNub.position

				//	Validar que exista una zona asignada
					if( mesa_zona > 0 )
					{
						App.totales( mesa_tipo , mesa_zona );
					}
				}
				else
				{
				//	Detener el Intervalo de actualización
					App.totales_actualizacion_detener();

				//	Iniciar animación de salida
					App.animar_salida_totales();

				//	Actualizar el valor
					mesa_totales_estado = false
				}
			}

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		/*

		//	Accion : Actualizar conteo total
			if( accion == 'recargar' )
			{
			//	Obtener información de la mesa
				const mesa_zona = datoPubNub.mesa_zona
				const mesa_tipo = datoPubNub.mesa_tipo

			//	Validar que exista una mesa
				if( mesa_totales_zona > 0 && mesa_totales_estado )
				{
				//	Validar que la mesa coincida
					if( mesa_totales_tipo == mesa_tipo && mesa_totales_zona == mesa_zona )
					{
					//	Actualizar mesa totales
						App.totales_actualizar()
					}
				}
			}

		*/

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
			const startValue = Number( element.innerText.replace('.','') );
			const newValueFormated = Number( newValue )
			
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
					const currentValue = Math.round(startValue + increment * progress);
	
					element.innerText = App.numero(currentValue);
					
					if (progress < 1)
					{
						requestAnimationFrame(update);
					}
					else
					{
						element.innerText = App.numero(currentValue);
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
			const api = await fetch( path_app + `/swich/mesas-totales/${tipo}-${zona}` )
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
			const api = await fetch( path_app + `/swich/mesas-totales/${mesa_totales_tipo}-${mesa_totales_zona}` )
			.then( res => res.json() )
			.then( res => res || [] );

			mesa_totales_mesas = api.mesas
			mesa_totales_votos = api.votos

		//	Almacenar listado de candidatos para gestionar actualizacion
			mesa_totales_candidatos = api.candidatos

		//	Validar que existan mesas en la Zona
			if( api.mesas > 0 )
			{
				if( mesa_totales_estado )
				{
					App.ordenar_votos_totales();
				}
			}
		},

	//	Asignar votos a la mesa de consolidados
		voto_totales : function( candidato , voto , accion )
		{
		//	Obtener el candidato desde el listado
			let candidato_obj = mesa_totales_candidatos.find(({ id }) => id === candidato);

		//	Validar que el candidato exista en el DOM
			if( candidato_obj )
			{
			//	Actualizar un voto
				if( accion == 'g' )
				{
				//	Actualizar mesa totales
					App.totales_actualizar()
					return
				}

			//	Sumar un voto
				else if( accion == 's' )
				{
				//	Actualizar el voto en el listado
					candidato_obj.votos += 1

				//	Actualizar el total de votos
					mesa_totales_votos += 1
				}

			//	Restar un voto
				else if( accion == 'r' )
				{
				//	Validar que el voto no sea cero
					if( voto != 0 )
					{
					//	Actualizar el voto en el listado
						candidato_obj.votos -= 1

					//	Actualizar el total de votos
						mesa_totales_votos -= 1
					}
					else
					{
					//	Actualizar mesa totales
						App.totales_actualizar()
						return
					}
				}

				const candidato_div_voto_animacion = document.querySelector('#candidato-' + candidato + ' > div.candidato-info > div.candidato-votos-animacion');
				candidato_div_voto_animacion.classList.add('animar_voto');

			//	Reiniciar animación del voto
				setTimeout(function()
				{
					candidato_div_voto_animacion.classList.remove('animar_voto');
				}, tiempo_transiciones);

			//	Ordenar candidatos
				App.ordenar_votos_totales();
			}
		},

	//	Ordenar Votos de los candidatos
		ordenar_votos_totales : function ()
		{
		//	Ordenar los candidatos por sus votos
			mesa_totales_candidatos.sort((a, b) => (b.votos > a.votos) ? 1 : (b.votos === a.votos) ? ((a.apellidos > b.apellidos) ? 1 : -1) : -1 )

		//	Orden del candidato
			let id_orden = 1;

		//	Iterar listado de candidatos
			mesa_totales_candidatos.forEach(candidato =>
			{
			//  Get object from DOM
				const candidato_div = document.getElementById(`candidato-${candidato.id}`);
				candidato_div.classList = `candidato order-${id_orden}`;

			//	Obtener valor del voto
				const candidato_voto_valor = document.getElementById(`candidato-${candidato.id}-votos`);

			//	Animar votos
				App.totales_actualizacion_votos(candidato_voto_valor , Number( candidato.votos ) , 1000 );

			//	Validar Posicion de los Objetos
				if( id_orden < 3 )
				{
					id_orden++	
				}
				else
				{
					id_orden = 4
				}
			});

		//	Calcular el total de votos
			App.calcular_votos_totales();
		},

	//	Calcular el total de votos
		calcular_votos_totales : function ()
		{
		//	Obtener contenedor de los totales
			const mesa_totales_detalles = document.getElementById('mesa-totales-detalles');
			
		//	Calcular el total de Votos
		//	const mesa_totales_votos =  mesa_totales_candidatos.reduce((total, candidato) => total + candidato.votos, 0);

		//	Actualizar el DOM
			mesa_totales_detalles.innerHTML = `${mesa_totales_mesas} <span>${ mesa_totales_mesas > 1 ? 'MESAS' : 'MESA' }</span>`
		//	mesa_totales_detalles.innerHTML = `${mesa_totales_mesas} MESAS&ensp;-&ensp;${App.numero(mesa_totales_votos)} VOTOS`
		},

	//	Dibujar la mesa en el DOM
		totales_draw : function()
		{
		//	Asignar tipo de zona
			const totales_zona = App.obtener_zona_region( mesa_totales_zona );

		//  DIV render en el DOM
			const render = document.getElementById('render-mesa-totales' );

		//	Vaciar el contenedor
			render.innerHTML = '';

		//	Crear el DIV de la mesa
			const div_mesa = document.createElement('div');
			div_mesa.id = 'mesa-0'

		//	Asignar las clases a la mesa
			div_mesa.className = `consolidados tipo-${mesa_totales_tipo.toLowerCase()}`

		//	Crear elementos en el DIV
			div_mesa.innerHTML =   `<div class="header">
										<div class="header-cnt">
											<h2 id="mesa-totales-detalles">
												${mesa_totales_mesas} <span>${ mesa_totales_mesas > 1 ? 'MESAS' : 'MESA' }</span>
											</h2>
											<h3 id="mesa-totales-zona">${totales_zona}</h3>
										</div>
									</div>
									<div class="motion"></div>
									<div class="candidatos" id="mesa-0-candidatos"></div>`;

		//	Dibujar la Mesa en el DOM
			render.appendChild(div_mesa);

		//	Render de los candidatos en la mesa
			const render_candidatos = document.getElementById('mesa-0-candidatos');

		//	Ordenar Candidatos por sus votos
			mesa_totales_candidatos.sort((a, b) => (b.votos > a.votos) ? 1 : (b.votos === a.votos) ? ((a.apellidos > b.apellidos) ? 1 : -1) : -1 )

		//	Indice del orden
			let id_orden = 1;

		//	Recorrer el listado de candidatos
			mesa_totales_candidatos.forEach(candidato =>
			{
			//	Crear el div contenedor del candidato
				const objeto = document.createElement('div');
				objeto.className = `candidato order-${id_orden}`

			//	Asignar las propiedades del div
				objeto.id = 'candidato-' + candidato.id

			//	Asignar los elementos al div
				objeto.innerHTML = `<div class="candidato-imagen">
										<div class="candidato-imagen-marco">
											<img
												src="${path_imagenes_candidatos}${candidato.id}.webp"
												class="candidato-imagen-src"
											/>
										</div>
										<div class="candidato-detalles-alianza">
											<div class="candidato-detalles-alianza-partido">
												${App.obtener_partido(candidato.partido)}
											</div>
											<div class="candidato-detalles-alianza-pacto">
												${App.obtener_pacto(candidato.pacto)}
											</div>
										</div>
									</div>
									<div class="candidato-info">
										<div class="candidato-detalles">
											<div class="candidato-detalles-nombre">${candidato.nombres}</div>
											<div class="candidato-detalles-apellido">${candidato.apellidos}</div>
										</div>
										<div class="candidato-votos">
											<div class="candidato-votos-valor" id="candidato-${candidato.id}-votos">${App.numero(candidato.votos)}</div>
										</div>
										<div class="candidato-votos-animacion"></div>
									</div>`

			//	Crear candidato en el listado
				render_candidatos.appendChild(objeto);

			//	Incrementar el ID de la lista
				id_orden++
			});

		//	Mostrar el pantalla
			App.animar_entrada_totales();
		},

	//	Cambiar el tamaño de texto
		validar_largo_zona : function(zona)
		{
		//	Obtener el elemento que contiene el texto
			const elemento = document.getElementById("mesa-totales-zona");
		
		//	Contar el largo del string
			const largoTexto = zona.length;

		//	Validar largo de la zona
			if (largoTexto <= 8)
			{
				elemento.style.fontSize = "2.4rem";
				elemento.style.lineHeight = "2.4rem";
			}
			else if (largoTexto <= 10)
			{
				elemento.style.fontSize = "2.3rem";
				elemento.style.lineHeight = "2.3rem";
			}
			else if (largoTexto <= 12)
			{
				elemento.style.fontSize = "2.2rem";
				elemento.style.lineHeight = "2.2rem";
			}
			else if (largoTexto <= 14)
			{
				elemento.style.fontSize = "2.1rem";
				elemento.style.lineHeight = "2.1rem";
			}
			else
			{
				elemento.style.fontSize = "1.75rem";
				elemento.style.lineHeight = "1.75rem";
			}
		},

	//	Animar la entrada del bloque
		animar_entrada_totales : function()	
		{
			render_mesa_totales.classList.remove('transition-on')

		//	Tipo de Mesa Gobernadores
			if( mesa_totales_posicion == 'r' )
			{
			//	Posicionar contenedor
				render_mesa_totales.style.bottom = mesa_totales_cordenadas.template_floating.oculta.y;
				render_mesa_totales.style.left = mesa_totales_cordenadas.template_floating.oculta.x;

			//	Espera para reparar el bug
				setTimeout(function()
				{
				//	Habilitar la animacion
					render_mesa_totales.classList.add('transition-on')

				//	Validar si existe mesa 1
					if( mesa_2 == null )
					{
					//	Asignar Posiciones en el eje X
						render_mesa_totales.style.bottom = mesa_totales_cordenadas.template_floating.visible.y;
						render_mesa_totales.style.left = mesa_totales_cordenadas.template_floating.visible.x;
					}
					else
					{
					//	Quitar la Mesa 1
						App.animar_salida_mesa_2();

					//	Corrección para el Bug del salto
						setTimeout(function()
						{
						//	Asignar Posiciones en el eje X
							render_mesa_totales.style.bottom = mesa_totales_cordenadas.template_floating.visible.y;
							render_mesa_totales.style.left = mesa_totales_cordenadas.template_floating.visible.x;

						}, tiempo_transiciones );
					}
				}, 200 );
			}

		//	Tipo de Mesa Alcaldes
			if( mesa_totales_posicion == 'l' )
			{
			//	Posicionar contenedor
				render_mesa_totales.style.bottom = mesa_totales_cordenadas.template_tottem.oculta.y;
				render_mesa_totales.style.left = mesa_totales_cordenadas.template_tottem.oculta.x;

			//	Espera para reparar el bug
				setTimeout(function()
				{
				//	Habilitar la animacion
					render_mesa_totales.classList.add('transition-on')

				//	Validar si existe mesa 1
					if( mesa_1 == null )
					{
					//	Asignar Posiciones en el eje X
						render_mesa_totales.style.bottom = mesa_totales_cordenadas.template_tottem.visible.y;
						render_mesa_totales.style.left = mesa_totales_cordenadas.template_tottem.visible.x;
					}
					else
					{
					//	Quitar la Mesa 1
						App.animar_salida_mesa_1();
		
					//	Corrección para el Bug del salto
						setTimeout(function()
						{
						//	Asignar Posiciones en el eje X
							render_mesa_totales.style.bottom = mesa_totales_cordenadas.template_tottem.visible.y;
							render_mesa_totales.style.left = mesa_totales_cordenadas.template_tottem.visible.x;
		
						}, tiempo_transiciones );
					}
				}, 200 );
			}

		//	Iniciar el intervalo de actualización
			App.totales_actualizacion_iniciar();
			
		//	Set estado del total
			mesa_totales_estado = true;
		},

	//	Animar la entrada del bloque
		animar_salida_totales : function()
		{
		//	Tipo de Mesa Gobernadores
			if( mesa_totales_posicion == 'r' )
			{
			//	Asignar Posiciones en el eje X
				render_mesa_totales.style.bottom = mesa_totales_cordenadas.template_floating.oculta.y;
				render_mesa_totales.style.left = mesa_totales_cordenadas.template_floating.oculta.x;

			//	Corrección para el Bug del salto
				setTimeout(function()
				{
					render_mesa_totales.classList.remove('transition-on')

				//	Validar mesas antes de desplegar
					if( app_modo == 0 && app_template != 0 && mesa_totales_estado == false  && mesa_2 != null )
					{
						App.animar_entrada_mesa_2();
					}

				}, tiempo_transiciones );
			}

		//	Tipo de Mesa Alcaldes
			if( mesa_totales_posicion == 'l' )
			{
			//	Asignar Posiciones en el eje X
				render_mesa_totales.style.bottom = mesa_totales_cordenadas.template_tottem.oculta.y;
				render_mesa_totales.style.left = mesa_totales_cordenadas.template_tottem.oculta.x;

			//	Corrección para el Bug del salto
				setTimeout(function()
				{
					render_mesa_totales.classList.remove('transition-on')

				//	Validar mesas antes de desplegar
					if( app_modo == 0 && app_template != 0 && mesa_totales_estado == false  && mesa_1 != null )
					{
						App.animar_entrada_mesa_1();
					}

				}, tiempo_transiciones );
			}

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

		//	Asignar modo de render
			if( app_modo == 0 )
			{
			//	Asignar clase al modo
				render_mesa_1.classList.remove('floating');
				render_mesa_1.classList.add('tottem');

				render_mesa_2.classList.remove('floating');
				render_mesa_2.classList.add('tottem');
			}
			else if( app_modo == 1 )
			{
			//	Asignar clase al modo
				render_mesa_1.classList.remove('floating');
				render_mesa_1.classList.add('tottem');

				render_mesa_2.classList.remove('floating');
				render_mesa_2.classList.add('tottem');
			}

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

		//	Validar que el template sea compatible
			if( app_template == 2 )
			{
			//	Asignar clase al modo
				render_mesa_1.classList.remove('template-1');
				render_mesa_1.classList.add('template-2');

			//	Asignar clase al modo
				render_mesa_2.classList.remove('template-1');
				render_mesa_2.classList.add('template-2');

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

					//	Validar template anterior
						if( app_modo == 0 )
						{
						//	Reiniciar Mesa
							render_mesa_2.classList.remove('transition-on')
							render_mesa_2.style.bottom = mesa_2_cordenadas.template_tottem.oculta.y;
							render_mesa_2.style.left = mesa_2_cordenadas.template_tottem.oculta.x;
							render_mesa_2.style.transform = mesa_2_cordenadas.template_tottem.oculta.z;
						}

					//	Validar template anterior
						if( app_modo == 1 )
						{
						//	Reiniciar Mesa
							render_mesa_2.classList.remove('transition-on')	
							render_mesa_2.style.bottom = mesa_2_cordenadas.template_floating.oculta.y;
							render_mesa_2.style.left = mesa_2_cordenadas.template_floating.oculta.x;
							render_mesa_2.style.transform = mesa_2_cordenadas.template_floating.oculta.z;
						}

					//	Dibujar la mesa en el DOM		
						App.draw( 2 , mesa_2 );
					}
				}
			}
			else
			{
			//	Vaciar el contenedor
				render_mesa_2.innerHTML = ''

			//	Asignar clase al modo
				render_mesa_1.classList.remove('template-2');
				render_mesa_1.classList.add('template-1');

			//	Asignar clase al modo
				render_mesa_2.classList.remove('template-2');
				render_mesa_2.classList.add('template-1');
			}

		//	Almacenar ID Historico de la Mesa
			if( api[switch_mesa_1] )
			{
				mesa_1_historico = api[switch_mesa_1].id
			}

			if( api[switch_mesa_2] )
			{
				mesa_2_historico = api[switch_mesa_2].id
			}

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
			div_mesa.className = `box tipo-${mesa.tipo.toLowerCase()} pos-${posicion}`

		//	Crear elementos en el DIV
			div_mesa.innerHTML =   `<div class="header">
										<h2>
											<span>${mesa.zona}</span>
											<div class="separador"></div>
											<span class="tipo">${mesa.comuna}</span>
										</h2>
										<h3>
											${mesa.local}
											<div class="separador"></div>
											${mesa.numero}
										</h3>
									</div>
									<div class="candidatos-padding">
										<div class="candidatos" id="mesa-${mesa.id}-candidatos"></div>
									</div>`;

        //	Dibujar la Mesa en el DOM
			render.appendChild(div_mesa);

		//	Render de los candidatos en la mesa
			const render_candidatos = document.getElementById('mesa-' + mesa.id + '-candidatos');

		//	Indice del orden
			let id_orden = 1;

		//	Ordenar los candidatos por sus votos
		//	mesa.candidatos.sort((a, b) => (b.votos > a.votos) ? 1 : (b.votos === a.votos) ? ((a.apellidos > b.apellidos) ? 1 : -1) : -1 )

        //	Recorrer el listado de candidatos
			mesa.candidatos.forEach(candidato =>
            {
            //	Crear el div contenedor del candidato
                const objeto = document.createElement('div');
				objeto.className = `candidato order-${id_orden}`

            //	Asignar las propiedades del div
                objeto.id = 'candidato-' + candidato.objeto

			//	Asignar los elementos al div
				objeto.innerHTML = `<div class="candidato-imagen">
										<div class="candidato-imagen-marco">
											<img
												src="${path_imagenes_candidatos}${candidato.id}.webp"
												class="candidato-imagen-src"
											/>
										</div>
									</div>
									<div class="candidato-info">
										<div class="candidato-detalles">
											<div class="candidato-detalles-nombre">${candidato.nombres}</div>
											<div class="candidato-detalles-apellido">${candidato.apellidos}</div>
											<div class="candidato-detalles-alianza">
												<div class="candidato-detalles-alianza-partido">
													${App.obtener_partido(candidato.partido_id)}
												</div>
												<div class="candidato-detalles-alianza-pacto">
													${App.obtener_pacto(candidato.pacto_id)}
												</div>
											</div>
										</div>
										<div class="candidato-votos">
											<div id="candidato-${candidato.objeto}-votos" class="candidato-votos-valor">${candidato.votos}</div>
										</div>
										<div id="candidato-${candidato.objeto}-animacion" class="candidato-votos-animacion"></div>
									</div>`

            //	Crear candidato en el listado
				render_candidatos.appendChild(objeto);

			//	Incrementar el ID de la lista
				id_orden++
            });

		//	Ordenar Votos de los candidatos
			App.ordenar_votos(mesa.candidatos);

		//	Asignar posición 2 en pantalla
			if( posicion == 1 )
			{
				if( app_template != 0 )
				{
					App.animar_entrada_mesa_1();
				}
			}

		//	Asignar posición 2 en pantalla
			if( posicion == 2 )
			{
				if( app_template != 0 )
				{
					App.animar_entrada_mesa_2();
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
				candidato_votos.innerHTML = votos;

			//	Obtener el contenedor de la animación
				const candidato_animacion = document.getElementById(`candidato-${id}-animacion`);
				candidato_animacion.classList.add('animar_voto');

				if( mesa_1 )
				{
					if( mesa == mesa_1.id)
					{
					//	Actualizar la cantidad de votos
						const result = mesa_1.candidatos.find(({ objeto }) => objeto === id);
						result.votos = votos;

					//	Actualizar DOM
						App.ordenar_votos(mesa_1.candidatos);
					}
				}

				if( mesa_2 )
				{
					if( mesa == mesa_2.id)
					{
					//	Actualizar la cantidad de votos
						const result = mesa_2.candidatos.find(({ objeto }) => objeto === id);
						result.votos = votos;

					//	Actualizar DOM
						App.ordenar_votos(mesa_2.candidatos);
					}
				}

			//	Esperar que la animación termine
				candidato_animacion.addEventListener('animationend' , function()
				{
				//	Eliminar la animación
					candidato_animacion.classList.remove('animar_voto');
				});
			}
		},

	//	Ordenar Votos de los candidatos
		ordenar_votos : function (candidatos)
		{
		//	Orden del candidato
			let id_orden = 1;

		//	Ordenar los votos de la mesa
			candidatos.sort((a, b) => (b.votos > a.votos) ? 1 : (b.votos === a.votos) ? ((a.orden > b.orden) ? 1 : -1) : -1 )

		//	Iterar listado de candidatos
			candidatos.forEach(candidato =>
			{
			//  Get object from DOM
				const candidato_div = document.getElementById(`candidato-${candidato.objeto}`);
				candidato_div.classList = `candidato order-${id_orden}`;

			//	Incrementar el ID de la lista
				id_orden++
			});
		},

	//			-			-			-			-			-			-			-			-			-			-			-

	//	Animar la entrada del bloque
		animar_entrada_mesa_1 : function()
		{
		//	Validar mesas antes de desplegar
			if( mesa_totales_estado && mesa_totales_posicion == 'l' )
			{
			//	Quitar Mesa de totales
				App.animar_salida_totales()

			//	Corrección para el Bug del salto
				setTimeout(function()
				{
					render_mesa_1.classList.add('transition-on')

				//	Asignar Posiciones en el eje X
					render_mesa_1.style.bottom = mesa_1_cordenadas.template_tottem.visible.y;
					render_mesa_1.style.left = mesa_1_cordenadas.template_tottem.visible.x;
					render_mesa_1.style.transform = mesa_1_cordenadas.template_tottem.visible.z;

				}, tiempo_transiciones );			
			}
			else
			{
			//	Asignar Posiciones en el eje X
				render_mesa_1.style.bottom = mesa_1_cordenadas.template_tottem.visible.y;
				render_mesa_1.style.left = mesa_1_cordenadas.template_tottem.visible.x;
				render_mesa_1.style.transform = mesa_1_cordenadas.template_tottem.visible.z;
			}
		},

	//	Animar la entrada del bloque
		animar_entrada_mesa_2 : function()
		{
		//	Validar mesas antes de desplegar
			if( mesa_totales_estado && mesa_totales_posicion == 'r' )
			{
			//	Quitar Mesa de totales
				App.animar_salida_totales()

			//	Corrección para el Bug del salto
				setTimeout(function()
				{
					render_mesa_2.classList.add('transition-on')

				//	Asignar Posiciones en el eje X
					render_mesa_2.style.bottom = mesa_2_cordenadas.template_tottem.visible.y;
					render_mesa_2.style.left = mesa_2_cordenadas.template_tottem.visible.x;
					render_mesa_2.style.transform = mesa_2_cordenadas.template_tottem.visible.z;

				}, tiempo_transiciones );			
			}
			else
			{
				setTimeout(function()
				{
					render_mesa_2.classList.add('transition-on')
	
				//	Asignar Posiciones en el eje X
					render_mesa_2.style.bottom = mesa_2_cordenadas.template_tottem.visible.y;
					render_mesa_2.style.left = mesa_2_cordenadas.template_tottem.visible.x;
					render_mesa_2.style.transform = mesa_2_cordenadas.template_tottem.visible.z;
	
				}, 200 );
			}
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

		//	if( mesa_totales_estado != true && mesa_id == null )
			if( mesa_id == null )
			{
				mesa_2_historico = 0
			}
		},

//			-			-			-			-			-			-			-			-			-			-			-

	//	Obtener información del tipo de Mesa
		obtener_tipo_mesa : function ( tipo )
		{
			if( tipo == 'G')
			{
				return 'GOBERNACIÓN';
			}
			if( tipo == 'A')
			{
				return 'ALCALDÍA'
			}
		},

	//	Obtener información del Partido
		obtener_zona_region : function ( id )
		{
			const region = objeto_regiones.find( obj => obj.id === Number(id) );
			return region.nombre;
		},

	//	Obtener información del Partido
		obtener_zona_comuna : function ( id )
		{
			const comuna = objeto_comunas.find( obj => obj.id === Number(id) );
			return comuna.nombre;
		},

	//	Obtener información del Partido
		obtener_partido : function ( id )
		{
			const partido = objeto_partidos.find( obj => obj.id === id );
			return partido.sigla;
		},

	//	Obtener información del Pacto
		obtener_pacto : function ( id )
		{
			const pacto = objeto_pactos.find( obj => obj.id === id );
			return pacto.letra;
		},

	//	Agregar miles a los numeros
		numero : function( valor )
		{
			return new Intl.NumberFormat('en-DE').format(valor);
		}
	}

//	Validación de las Imagenes
	const candidato_poster = async ( id ) =>
	{
		//	Actualizar votos en el DOM
		const candidato_voto = document.getElementById(`mesa-${id}-candidatos`);

	//	Recorrer las imagenes de los candidatos
		Array.from(candidato_voto.querySelectorAll('.candidato-imagen-src')).forEach(function(e)
		{
			candidato_poster_crear( id , e.dataset.objeto );
		});
	}

//	Validar la imagen del Candidato
	const candidato_poster_crear = async ( mesa , id ) =>
	{
	//	Obtener información del objeto
		const objeto = document.getElementById('candidato-imagen-' + mesa + '-' + id);

	//	Version de cache de las imagenes
		const version = '1.1.3';

	//	Construir ruta de la imagen
		const objeto_imagen = path_imagenes_candidatos + objeto.dataset.objeto + '.webp?v=' + version;

	//	Solicitar la imagen
		await fetch( objeto_imagen , { method: 'GET' }).then(res =>
		{
			if ( res.ok )
			{
				objeto.src = objeto_imagen;
				objeto.style.opacity = 1
				objeto.dataset.load = true
			}
			else
			{
				objeto.src = path_imagenes_candidatos_error
				objeto.style.opacity = 1
				objeto.dataset.load = false

				console.log( '[404]' , objeto.dataset.objeto , '-' , objeto.dataset.nombre );
			}
		});
	}

//	Iniciar las Zonas
	App.zone();