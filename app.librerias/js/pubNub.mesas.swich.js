//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	FUNCIONALIDAD PUBNUB PARA EL SWICH
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Estado de los cambios en la configuracion
	var swich_cambios = 0;

//	Estado de la actualización de datos
	var recargar_estado = 0;

//	Definir valores anteriores
	var swich_modo_anterior = 0;
	var swich_mesas_anterior = 0;

	let swich_mesa_1_historico = 0
	let swich_mesa_2_historico = 0

//	Total de mesas
	let mesas_totales = 0

//	Intervalo de validación de mesa nueva
	let mesas_timer = null

//	Intervalo de tiempo entre comprobación
	const mesas_nueva_comparacion = 5000

//	Iniciar al Cargar
	$(function()
	{
	//	Almacenar el total de mesas
		mesas = document.querySelectorAll('#mesas > article')

	//	Actualizar el total de mesas
		mesas_totales = mesas.length

	//	Mover Mesas Almacenadas
		cargarSwich();
	});

//	Iniciar intervalo de actualización de los totales
	function mesa_nueva_iniciar()
	{
	//	Validar si la mesa es nueva
		mesas_ultima_actualizacion();

	//	Validar si el timer esta activo
		if (mesas_timer === null)
		{
			mesas_timer = setInterval( mesas_ultima_actualizacion , mesas_nueva_comparacion);
		}
	}

//	Detener intervalo de actualización de los totales
	function mesa_nueva_detener()
	{
		if (mesas_timer !== null)
		{
			clearInterval(mesas_timer);
			mesas_timer = null;
		}
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Iniciar PubNub
	pubnub.addListener(
	{
	//	Recibir Mensajes
		message: function(message)
		{
		//	Obtener Nuevo Dato
			let datoPubNub			=	message.message;

		//	Obtener Accion desde PubNub
			let accion				=	datoPubNub.accion;

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Accion : Actualizar el contenido
			if( accion == 'recargar' )
			{
			//	Actualizar Mesas del listado
				actualizarMesas();
			}

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Accion : Voto Emitido
			if( accion == 'voto' )
			{
			//	Obtener ID de la Mesa
				const mesa_id = datoPubNub.mesa;

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

					//	Cambiar el color del estado
						mesa_voto.parentElement.classList.remove('verde', 'amarillo', 'rojo');
						mesa_voto.parentElement.classList.add('verde');

					//	Asignar Fecha actual
						const mesa_voto_date = document.getElementById(mesa_id + '_mesa_cambio');
						mesa_voto_date.innerHTML = `<time class="timeago line-1" data="${mesa_id}"  datetime="${ Math.floor(message.timetoken / 10000000) }">Hace 1 segundo</time>`
					});
				}
			}
		}
	});

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Suscribir al Canal PubNub
    pubnub.subscribe(
	{
        channels: ['vav_mesas'],
    //	withPresence: true
    });

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Actualizar el listado de mesas
	async function actualizarMesas()
	{
	//	Detener la validación de nuevas mesas
		mesa_nueva_detener();

	//	Solicitar la mesa asignada
		const api = await fetch( path_app + '/swich/mesas-controlador/' )
		.then( res => res.json() )
		.then( res => res || [] );

	//		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Actualizar valores globales
		swich_modo		=	api.switch.swich_modo;
		swich_mesas		=	api.switch.swich_mesas;
		swich_mesa_1	=	api.switch.swich_mesa_1;
		swich_mesa_2	=	api.switch.swich_mesa_2;
		swich_mesa_3	=	api.switch.swich_mesa_3;
		swich_mesa_4	=	api.switch.swich_mesa_4;

	//		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Obtener el contenedor de las mesas
		const render = document.getElementById('mesas' );
		render.innerHTML = '';

	//	Iterar mesas disponibles
		api.mesas.forEach(mesa =>
		{
		//	Crear el div contenedor del candidato
			const objeto = document.createElement('article');
			
		//	Asignar las propiedades del div
			objeto.id = 'MES' + mesa.mesa_id
			objeto.className = `mesa mesa-swich bg-blanco box-shadow bordes-radius filtro-mesa ${mesa.mesa_tipo} rojo`
			
			objeto.setAttribute('mesa', mesa.mesa_id);
			objeto.setAttribute('date', mesa.mesa_cambio);
			objeto.setAttribute('created', mesa.mesa_publicado);

		//	Definir el tipo de mesa
			let mesa_tipo = ''

		//	Validar tipo de mesa
			if( mesa.mesa_tipo == 'G' )
			{
				mesa_tipo = '🔴&nbsp;&nbsp;&nbsp;GOBERNADORES';
			}
			else if( mesa.mesa_tipo == 'A' )
			{
				mesa_tipo = '🔵&nbsp;&nbsp;&nbsp;ALCALDES';
			}
			else if( mesa.mesa_tipo == 'P' )
			{
				mesa_tipo = '🔴&nbsp;&nbsp;&nbsp;PRESIDENCIALES';
			}
			else if( mesa.mesa_tipo == 'S' )
			{
				mesa_tipo = '🔵&nbsp;&nbsp;&nbsp;SENADORES';
			}
			else if( mesa.mesa_tipo == 'D' )
			{
				mesa_tipo = '🟠&nbsp;&nbsp;&nbsp;DIPUTADOS';
			}

		//	Asignar los elementos al div
			objeto.innerHTML = `<div class="mesa-nueva">NUEVA</div>
								<div id="mesa-voto-${mesa.mesa_id}" class="cambios bordes-radius"></div>
								<header>
									<h2 class="${ mesa.mesa_destacada == 1 ? 'importante' : '' }">
										<i class="fas ${ mesa.mesa_destacada == 1 ? 'fa-star' : ' fa-hashtag'}"></i> ${mesa.mesa_id}
									</h2>
									<div class="tipo">${mesa_tipo}</div>
									<div class="zona">${mesa.mesa_zona_titulo}</div>
									<h3 class="line-1" id="${mesa.mesa_id}_mesa_nombre">${mesa.mesa_local}</h3>
									<h4 class="line-1" id="${mesa.mesa_id}_mesa_numero">${mesa.mesa_numero}</h4>
									<h5 class="line-1" id="${mesa.mesa_id}_mesa_ciudad"><i class="fas fa-globe-americas"></i> ${mesa.mesa_comuna}</h5>
									<h6 class="line-1" id="${mesa.mesa_id}_mesa_cambio"><time class="timeago line-1" data="${mesa.mesa_id}" datetime="${mesa.mesa_cambio}"></time></h6>
								</header>`

		//	Crear candidato en el listado
			render.appendChild(objeto);
		});

	//	Mover Mesas Almacenadas
		cargarSwichReload();

	//	Actualizar el total de mesas
		mesas_totales = api.mesas.length

	//	Actualizar el numero total de mesas en pantalla
		mesas_totales_actualizacion();
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Mover Mesas Almacenadas
	function cargarSwich()
	{
	//	Destruir Funcionalidad Sortable
		$('.relacionados').sortable('destroy');
		
	//	Validar Espacio 1
		if( swich_mesa_1 != 0 )
		{
			let	mesa	=	$( "#MES" + swich_mesa_1 );
			mesa.clone().prependTo('#mesa-1');
			mesa.remove();
		}
		
	//	Validar Espacio 2
		if( swich_mesa_2 != 0 )
		{
			let mesa	=	$( "#MES" + swich_mesa_2 );
			mesa.clone().prependTo('#mesa-2');
			mesa.remove();
		}
		
	//	Validar Espacio 3
		if( swich_mesa_3 != 0 )
		{
			let mesa	=	$( "#MES" + swich_mesa_3 );
			mesa.clone().prependTo('#mesa-3');
			mesa.remove();
		}
		
	//	Validar Espacio 4
		if( swich_mesa_4 != 0 )
		{
			let mesa	=	$( "#MES" + swich_mesa_4 );
			mesa.clone().prependTo('#mesa-4');
			mesa.remove();
		}
		
	//	Iniciar Funcionalidad Sortable
		$( ".relacionados" ).sortable(
		{
			placeholder: "drag",
			connectWith: ".relacionados"
		});

	//	Marcar modo de render
		$("#swich-opcion-modo-" + swich_modo).removeClass("of").addClass("on");

	//	Marcar Numero de Mesas a Mostrar
		$("#swich-opcion-mesas-" + swich_mesas).removeClass("of").addClass("on");
		
	//	Marcar Tipo de Votos a Mostrar
		$("#swich-opcion-votos-" + swich_votos).removeClass("of").addClass("on");
		
	//	Validar Template y mesas Seleccionado
		swichMesasActivas( swich_mesas );

	//	Iniciar el intervalo para validar las mesas nuevas
		mesa_nueva_iniciar();

	//	Actualizar el numero total de mesas en pantalla
		mesas_totales_actualizacion();
	}

//	Mover Mesas Almacenadas
	function cargarSwichReload()
	{
	//	Destruir Funcionalidad Sortable
		$('.relacionados').sortable('destroy');
		
	//	Obtener Listado de Mesas en el Listado
		$( '#mesa-1 > article' ).each(function()
		{
			let mesa	=	$("#" + $(this).attr('id'));
			mesa.remove();
		});

		$( '#mesa-2 > article' ).each(function()
		{
			let mesa	=	$("#" + $(this).attr('id'));
			mesa.remove();
		});
		
	//	Iniciar Funcionalidad Sortable
		$( ".relacionados" ).sortable(
		{
			placeholder: "drag",
			connectWith: ".relacionados"
		});

	//	Iniciar la validación de nuevas mesas
		mesa_nueva_iniciar();
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Vaciar Mesas del Espacio
	function vaciarEspacio(id)
	{
	//	Destruir Funcionalidad Sortable
		$('.relacionados').sortable('destroy');
		
	//	Obtener Listado de Mesas en el Listado
		$( '#mesa-' + id + ' > article' ).each(function()
		{
			let mesa	=	$("#" + $(this).attr('id'));
			mesa.clone().prependTo('#mesas');
			mesa.remove();
		});
		
	//	Reiniciar Funcionalidad Sortable
		$( ".relacionados" ).sortable(
		{
			placeholder: "drag",
			connectWith: ".relacionados"
		});
		
	//	Aplicar Cambios a los Botones
		swich_cambios	=	1;

	//	Estado de Cambios en el Swich
		estadoSwich();
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Vaciar Total de Mesas del Espacio
	function espacioValidar()
	{
	//	Destruir Funcionalidad Sortable
		$('.relacionados').sortable('destroy');

	//	ID del Listado
		var i	=	0;

	//	Obtener Listado de Mesas en el Listado 1
		$( '#mesa-1 > .mesa-swich' ).each(function()
		{
		//	Excluir el Primer Child
			if( i > 0 )
			{
			//	Mover Mesa al Listado Principal
			let mesa	=	$("#" + $(this).attr('id'));
				mesa.clone().prependTo('#mesas');
				mesa.remove();
			}
			
		//	Aumentar Child
			i++;
		});

	//		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	ID del Listado
		var i	=	0;

	//	Obtener Listado de Mesas en el Listado 2
		$( '#mesa-2 > .mesa-swich' ).each(function()
		{
		//	Excluir el Primer Child
			if( i > 0 )
			{
			//	Mover Mesa al Listado Principal
			let mesa	=	$("#" + $(this).attr('id'));
				mesa.clone().prependTo('#mesas');
				mesa.remove();
			}
			
		//	Aumentar Child
			i++;
		});

	//		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	ID del Listado
		var i	=	0;

	//	Obtener Listado de Mesas en el Listado 3
		$( '#mesa-3 > .mesa-swich' ).each(function()
		{
		//	Excluir el Primer Child
			if( i > 0 )
			{
			//	Mover Mesa al Listado Principal
			let mesa	=	$("#" + $(this).attr('id'));
				mesa.clone().prependTo('#mesas');
				mesa.remove();
			}
			
		//	Aumentar Child
			i++;
		});

	//		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	ID del Listado
		var i	=	0;

	//	Obtener Listado de Mesas en el Listado 4
		$( '#mesa-4 > .mesa-swich' ).each(function()
		{
		//	Excluir el Primer Child
			if( i > 0 )
			{
			//	Mover Mesa al Listado Principal
			let mesa	=	$("#" + $(this).attr('id'));
				mesa.clone().prependTo('#mesas');
				mesa.remove();
			}
			
		//	Aumentar Child
			i++;
		});

	//	Reiniciar Funcionalidad Sortable
		$( ".relacionados" ).sortable(
		{
			placeholder: "drag",
			connectWith: ".relacionados"
		});
		
	//	Estado de Cambios en el Swich
		estadoSwich();
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Estado de Cambios en el Swich
	function estadoSwich()
	{
	//	Cambiar Estado de los Botones
		if(swich_cambios == 0)
		{
			$("#cambios-on").css("display","none");
			$("#cambios-of").css("display","block");
		}
		else
		{
			$("#cambios-on").css("display","block");
			$("#cambios-of").css("display","none");
		}
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Seleccionar Numero de Mesas a Mostrar
	function swichMesas( id )
	{
	//	Guardar opcion seleccionada
		swich_mesas		=	id;
		
	//	Obtener Listado de Mesas en el Listado
		$( '#swich-opcion-mesas > div' ).each(function()
		{
			$(this).removeClass("on").addClass("of");
		});

	//	Destacar la Opcion seleccionada
		$("#swich-opcion-mesas-" + id).removeClass("of").addClass("on");

	//	Validar Template y mesas Seleccionado
		swichMesasActivas( id );

	//	Aplicar Cambios a los Botones
		swich_cambios	=	1;

	//	Estado de Cambios en el Swich
		estadoSwich();
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Validar Template y mesas Seleccionado
	function swichMesasActivas( id )
	{
	//	Template 1 Mesa
		if( swich_mesas == 0 )
		{
			$("#swich-mesa-1").css("opacity","0.5");
			$("#swich-mesa-1").css("filter","blur(0.075rem)");
			
			$("#swich-mesa-2").css("opacity","0.5");
			$("#swich-mesa-2").css("filter","blur(0.075rem)");
			
			$("#swich-mesa-3").css("opacity","0.5");
			$("#swich-mesa-3").css("filter","blur(0.075rem)");
			
			$("#swich-mesa-4").css("opacity","0.5");
			$("#swich-mesa-4").css("filter","blur(0.075rem)");
		}
		
	//	Template 1 Mesa
		if( swich_mesas == 1 )
		{
			$("#swich-mesa-1").css("opacity","1");
			$("#swich-mesa-1").css("filter","blur(0rem)");
			
			$("#swich-mesa-2").css("opacity","0.5");
			$("#swich-mesa-2").css("filter","blur(0.075rem)");
			
			$("#swich-mesa-3").css("opacity","0.5");
			$("#swich-mesa-3").css("filter","blur(0.075rem)");
			
			$("#swich-mesa-4").css("opacity","0.5");
			$("#swich-mesa-4").css("filter","blur(0.075rem)");
		}

	//	Template 2 Mesas
		if( swich_mesas == 2 )
		{
			$("#swich-mesa-1").css("opacity","1");
			$("#swich-mesa-1").css("filter","blur(0rem)");

			$("#swich-mesa-2").css("opacity","1");
			$("#swich-mesa-2").css("filter","blur(0rem)");
			
			$("#swich-mesa-3").css("opacity","0.5");
			$("#swich-mesa-3").css("filter","blur(0.075rem)");
			
			$("#swich-mesa-4").css("opacity","0.5");
			$("#swich-mesa-4").css("filter","blur(0.075rem)");
		}

	//	Template 3 Mesas
		if( swich_mesas == 3 )
		{
			$("#swich-mesa-1").css("opacity","1");
			$("#swich-mesa-1").css("filter","blur(0rem)");

			$("#swich-mesa-2").css("opacity","1");
			$("#swich-mesa-2").css("filter","blur(0rem)");
			
			$("#swich-mesa-3").css("opacity","1");
			$("#swich-mesa-3").css("filter","blur(0rem)");
			
			$("#swich-mesa-4").css("opacity","0.5");
			$("#swich-mesa-4").css("filter","blur(0.075rem)");
		}

	//	Template 4 Mesas
		if( swich_mesas == 4 )
		{
			$("#swich-mesa-1").css("opacity","1");
			$("#swich-mesa-1").css("filter","blur(0rem)");

			$("#swich-mesa-2").css("opacity","1");
			$("#swich-mesa-2").css("filter","blur(0rem)");
			
			$("#swich-mesa-3").css("opacity","1");
			$("#swich-mesa-3").css("filter","blur(0rem)");
			
			$("#swich-mesa-4").css("opacity","1");
			$("#swich-mesa-4").css("filter","blur(0rem)");
		}		
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Seleccionar Modo a mostrar
	function swichModo( id )
	{
	//	Guardar opcion seleccionada
		swich_modo		=	id;
		
	//	Obtener Listado de Mesas en el Listado
		$( '#swich-opcion-modo > div' ).each(function()
		{
			$(this).removeClass("on").addClass("of");
		});

	//	Destacar la Opcion seleccionada
		$("#swich-opcion-modo-" + id).removeClass("of").addClass("on");

	//	Aplicar Cambios a los Botones
		swich_cambios	=	1;

	//	Estado de Cambios en el Swich
		estadoSwich();
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
	
//	Editar las Mesas que serán Mostradas
	function swichGuardar()
	{
	//	Obtener ID de las Mesas
		let swich_mesa_1			=	$( "#mesa-1 > .mesa-swich" ).first().attr('mesa');
		let swich_mesa_2			=	$( "#mesa-2 > .mesa-swich" ).first().attr('mesa');
		let swich_mesa_3			=	$( "#mesa-3 > .mesa-swich" ).first().attr('mesa');
		let swich_mesa_4			=	$( "#mesa-4 > .mesa-swich" ).first().attr('mesa');

	//	Actualizar de las Mesas
		$.post( path_app + '/swich/editar/' ,
		{
			swich_id				:	swich_id,
			swich_modo				:	swich_modo,
			swich_mesas				:	swich_mesas,
			swich_mesa_1			:	swich_mesa_1,
			swich_mesa_2			:	swich_mesa_2,
			swich_mesa_3			:	swich_mesa_3,
			swich_mesa_4			:	swich_mesa_4,
			swich_votos				:	swich_votos
		})
		.done(function( data )
		{
		//	Aplicar Cambios a los Botones
			swich_cambios	=	0;

		//	Estado de Cambios en el Swich
			estadoSwich();
			
        //	Construir Variable para enviar a PubNub
            let pubnub       	=
            {
                'accion'		:	'switch',
                'modo'          :	swich_modo,
				'template'		:	swich_mesas,
                'mesa_1'		:	Number(swich_mesa_1),
				'mesa_2'		:	Number(swich_mesa_2)
            }

        //	Enviar Notificación a PubNub
			enviarPubNub( pubnub );

		//	Esperar para realizar cambios
			if( recargar_estado == 1 )
			{
			//	Actualizar Pagina
				location.reload();
			}

		//	Validar modo actual
			if( swich_mesas != 0 && estado_consolidados == 'on'  )
			{
			//	Validar tipo de mesa gobernador
				if( posicion_consolidados == 'r' && swich_mesas >= 2 )
				{
					if( swich_mesa_2 != undefined )
					{
					//	Desactivar consolidados
					//	estadoConsolidadosActual('of');
					}
				}

			//	Validar tipo de mesa alcalde
				if( posicion_consolidados == 'l' && swich_mesas >= 1 )
				{
					if( swich_mesa_1 != undefined )
					{
					//	Desactivar consolidados
					//	estadoConsolidadosActual('of');
					}
				}

			//	Almacenar modo actual
				swich_modo_anterior = swich_modo;
			}

		//	Validar coincidencia entre los modos
			if( swich_modo != swich_modo_anterior )
			{
				//	Desactivar consolidados
				//	estadoConsolidadosActual('of');

				//	Almacenar modo actual
				swich_modo_anterior = swich_modo;
			}

		//	Almacenar Mesas en historico
			swich_mesa_1_historico		=	swich_mesa_1;
			swich_mesa_2_historico		=	swich_mesa_2;
		});
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
	
//	Editar las Mesas que serán Mostradas
	function swichQuadGuardar()
	{
	//	Obtener ID de las Mesas
		let swich_mesa_1			=	$( "#mesa-1 > .mesa-swich" ).first().attr('mesa');
		let swich_mesa_2			=	$( "#mesa-2 > .mesa-swich" ).first().attr('mesa');
		let swich_mesa_3			=	$( "#mesa-3 > .mesa-swich" ).first().attr('mesa');
		let swich_mesa_4			=	$( "#mesa-4 > .mesa-swich" ).first().attr('mesa');

	//	Actualizar de las Mesas
		$.post( path_app + '/swich/editar/' ,
		{
			swich_id				:	swich_id,
			swich_modo				:	swich_modo,
			swich_mesas				:	swich_mesas,
			swich_mesa_1			:	swich_mesa_1,
			swich_mesa_2			:	swich_mesa_2,
			swich_mesa_3			:	swich_mesa_3,
			swich_mesa_4			:	swich_mesa_4,
			swich_votos				:	swich_votos
		})
		.done(function( data )
		{
		//	Aplicar Cambios a los Botones
			swich_cambios	=	0;

		//	Estado de Cambios en el Swich
			estadoSwich();
			
		//	Construir Variable para enviar a PubNub
			let pubnub       	=
			{
				'accion'		:	'switchQuad',
				'modo'          :	swich_modo,
				'template'		:	swich_mesas,
				'mesa_1'		:	Number(swich_mesa_1),
				'mesa_2'		:	Number(swich_mesa_2),
				'mesa_3'		:	Number(swich_mesa_3),
				'mesa_4'		:	Number(swich_mesa_4)
			}

		//	Enviar Notificación a PubNub
			enviarPubNub( pubnub );

		//	Esperar para realizar cambios
			if( recargar_estado == 1 )
			{
			//	Actualizar Pagina
				location.reload();
			}

		//	Validar modo actual
			if( swich_modo == 1 && swich_mesas == 2 && estado_consolidados == 'on' && swich_mesa_2_historico != swich_mesa_2  )
			{
				if( swich_mesa_2 != undefined )
				{
				//	Desactivar consolidados
					estadoConsolidadosActual('of');

				//	Almacenar modo actual
					swich_modo_anterior = swich_modo;
				}
			}

			if( swich_modo != swich_modo_anterior )
			{
				//	Desactivar consolidados
				estadoConsolidadosActual('of');

				//	Almacenar modo actual
				swich_modo_anterior = swich_modo;
			}

		//	Almacenar Mesas en historico
			swich_mesa_1_historico		=	swich_mesa_1;
			swich_mesa_2_historico		=	swich_mesa_2;
		});
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
	
	let estado_preview_switch = false;
	let estado_preview_consolidado = false;

//	Iniciar Preview Switch
	function swichPreview()
	{
	//	Validar estado del preview
		if( estado_preview_switch == true )
		{
			return
		}
		else
		{
		//	Obtener ID de las Mesas
			let swich_mesa_1			=	$( "#mesa-1 > .mesa-swich" ).first().attr('mesa');
			let swich_mesa_2			=	$( "#mesa-2 > .mesa-swich" ).first().attr('mesa');
			let swich_mesa_3			=	$( "#mesa-3 > .mesa-swich" ).first().attr('mesa');
			let swich_mesa_4			=	$( "#mesa-4 > .mesa-swich" ).first().attr('mesa');

		//	Actualizar de las Mesas
			$.post( path_app + '/swich/editar/' ,
			{
				swich_id				:	1,
				swich_modo				:	swich_modo,
				swich_mesas				:	swich_mesas,
				swich_mesa_1			:	swich_mesa_1,
				swich_mesa_2			:	swich_mesa_2,
				swich_mesa_3			:	swich_mesa_3,
				swich_mesa_4			:	swich_mesa_4,
				swich_votos				:	swich_votos
			})
			.done(function( data )
			{
			//	Construir Variable para enviar a PubNub
				let pubnub       	=
				{
					'accion'		:	'switch_preview',
					'modo'          :	swich_modo,
					'template'		:	swich_mesas,
					'mesa_1'		:	Number(swich_mesa_1),
					'mesa_2'		:	Number(swich_mesa_2)
				}

			//	Enviar Notificación a PubNub
				enviarPubNub( pubnub );

			//	Actualizar el valor de estado
				estado_preview_switch = true;

			//	Buscar mesa en el DOM
				const boton_preview = document.getElementById('estado-preview-switch');

			//	Asignar clase con la animación
				boton_preview.classList.add('animacionEstadoPreview');

			//	Esperar que la animación termine
				boton_preview.addEventListener('animationend' , function()
				{
				//	Eliminar la animación
					boton_preview.classList.remove('animacionEstadoPreview');

				//	Actualizar el valor de estado
					estado_preview_switch = false;
				});
			});
		}
	}

//	Iniciar Preview Consolidados
	function consolidadosPreview()
	{
	//	Validar estado del preview
		if( estado_preview_consolidado == true )
		{
			return
		}
		else
		{
			//	Construir Variable para enviar a PubNub
			let pubnub       	=
			{
				'accion'		:	'consolidados_preview',
				'estado'        :	'on',
				'position'		:	posicion_consolidados,
				'tipo'          :   $.cookie('consolidado_tipo'),
				'zona'          :   $.cookie('consolidado_zona')
			}

		//	Enviar Notificación a PubNub
			enviarPubNub( pubnub );

		//	Actualizar el valor de estado
			estado_preview_consolidado = true;

		//	Buscar mesa en el DOM
			const boton_preview = document.getElementById('estado-preview-consolidados');

		//	Asignar clase con la animación
			boton_preview.classList.add('animacionEstadoPreview');

		//	Esperar que la animación termine
			boton_preview.addEventListener('animationend' , function()
			{
			//	Eliminar la animación
				boton_preview.classList.remove('animacionEstadoPreview');

			//	Actualizar el valor de estado
				estado_preview_consolidado = false;
			});
		}
	}
