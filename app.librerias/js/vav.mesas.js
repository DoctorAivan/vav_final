//  Tipo de Mesa
var mesa_id                         =   0;
var mesa_tipo                       =   '';
var mesa_zona                       =   '';
var mesa_zona_titulo                =   '';
var mesa_nueva_comuna               =   '';
var mesa_usuario                    =   '';
var mesa_filtro                     =   0;

var mesa_candidatos                 =   Array();
var mesa_estado_guardado            =   '';

var objeto_regiones                 =   [];
var objeto_circunscripciones        =   [];
var objeto_distritos                =   [];
var objeto_candidatos               =   [];

var estado_consolidados             =   'of';
var posicion_consolidados           =   'l';

var estado_consolidados_animacion   =   false;

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Iniciar al Cargar
$(function()
{
//	Obtener Valor Guardado
    var mesa_votos	=	$.cookie('vav_mesas_votos');

//	Mostrar tipo de Votos
    mesa_filtrar( '' );

//  Obtener Diccionario de Gobernadores
    $.getJSON( path_app + '/app.librerias/zonas.json' , function( json )
    {
    //  Alimentar objeto con las regiones
        objeto_regiones = json.regiones;

    //  Alimentar objeto con las provincias
        objeto_provincias = json.provincias

    //  Alimentar objeto con las circunscripciones
        objeto_circunscripciones = json.circunscripciones;

    //  Alimentar objeto con los distritos
        objeto_distritos = json.distritos;

    //  Alimentar objeto con las comunas
        objeto_comunas = json.comunas;
    });

//  Consolidados estados
    const vav_cons_estado = $.cookie('vav_cons_estado');

//  Consolidados posicion
    const vav_cons_posicion = $.cookie('vav_cons_posicion');

//  Autocompletar el Estado de Consolidados
    estadoConsolidadosActual( vav_cons_estado );

//  Autocompletar la Posicion de Consolidados
    posicionConsolidadosActual( vav_cons_posicion );
});

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//  Mesa Nueva
function mesa_nueva()
{
//  Cambiar la dimensión
    liveboxAncho('mesa' , 500 );

//	Abrir Funcionalidad Livebox
    liveboxAbrir('mesa');

//  Marcar Pacto por Defecto
    mesa_nueva_tipo('G');

//  Generar Listado de Regiones
//  mesa_nueva_regiones_listado();

//  Crear funcionalidad autocompletar
    mesa_nueva_autocompletar_comunas();

//  Limpiar input comunas
    const input_comunas = document.getElementById('mesa_nueva_comuna')
    input_comunas.value = ''

//  Funcionalidad Botones nueva mesa
    const mensa_nueva_of = document.getElementById('mesa-nueva-of')
    const mensa_nueva_on = document.getElementById('mesa-nueva-on')

//  Estado de los botones de accion
    mensa_nueva_of.style.display = 'block';
    mensa_nueva_on.style.display = 'none';
}

//  Mesa Nueva Confirmación
function mesa_nueva_confirmar()
{
//	Mostrar Usabilidad Cargando
    liveboxCargando();

//  Post Data
    $.post( path_app + '/mesas/nueva/' ,
    {
        mesa_tipo                   :  mesa_tipo,
        mesa_zona                   :  mesa_zona,
        mesa_comuna                 :  mesa_nueva_comuna,
        mesa_zona_titulo            :  mesa_zona_titulo
    })
    .done(function( id )
    {
    //  Almacenar ID de la mesa
        mesa_id     =   id;

    //	Cambiar de Livebox
        liveboxCambio();

    //  Mostrar detalles de una Mesa
        mesa_detalles( id );
    });
}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//  Crear funcionalidad autocompletar
function mesa_nueva_autocompletar_comunas()
{
//  Crear objeto autocompletar
    let options = {
        data: objeto_comunas,
        getValue: "nombre",
        list: {
            maxNumberOfElements: 5,
            match: {
                enabled: true
            }
        },
        template: {
            type: "custom",
            method: function(value, objeto)
            {
            //  Obtener Nombre de la Región
                let region = objeto_regiones.find( obj => obj.id === objeto.region );

            //  Crear div con el resultado
                let div     =   `<div class="box" onClick="nueva_mesa_zona(${objeto.id})">
                                    <div class="child">${value}</div>
                                    <div class="parent">${region.nombre}</div>
                                </div>`;

            //  Enviar resultado a la UI
                return div;
            }
        }
    };

//  Asignar funcionalidad
    $("#mesa_nueva_comuna").easyAutocomplete(options);
}

//  Mesa Nueva Zona
function nueva_mesa_zona( id )
{
//  Obtener información de la Comuna
    let comuna = objeto_comunas.find( obj => obj.id === id );

//  Obtener la Circunscripcion de la Comuna
    let region = objeto_regiones.find( obj => obj.id === comuna.region );

//  Tipo Zona Gobernador
    if( mesa_tipo == 'G' )
    {
        mesa_zona = region.id;
        mesa_zona_titulo = region.nombre;
    }

//  Tipo Zona Alcalde
    if( mesa_tipo == 'A' )
    {
        mesa_zona = comuna.id;
        mesa_zona_titulo = comuna.nombre;
    }

//  Almacenar Nombre de la comuna
    mesa_nueva_comuna = comuna.nombre;

//  Funcionalidad Botones nueva mesa
    const mensa_nueva_of = document.getElementById('mesa-nueva-of')
    const mensa_nueva_on = document.getElementById('mesa-nueva-on')

//  Estado de los botones
    mensa_nueva_of.style.display = 'none';
    mensa_nueva_on.style.display = 'block';
}

//  Mesa Nueva Tipo
function mesa_nueva_tipo( tipo )
{
//  Quitar seleccion
    $( '#mesa-tipo div' ).each(function()
    {
        $( this ).removeClass( 'on' );
    });

//  Destacar Opción
    $( '#mesa-tipo-' + tipo ).addClass( 'on' );

//  Almacenar tipo de Mesa
    mesa_tipo       =   tipo;
}

//  Generar listado de regiones
function mesa_nueva_regiones_listado()
{
//  Crear elemento
    let div = '';

//  Crear elemento en el objeto
    $.each( objeto_regiones , function( i, region )
    {
        div += `<div onclick="mesa_nueva_regiones_listado_marcar(${region.i});" id="region-listado-id-${region.i}" class="regiones-listado-box">
                    <div class="codigo">${region.r}</div>
                    <div class="nombre">${region.n}</div>
                </div>`;
    });

//  Asignar las regiones al DOM
    $('#mesa-regiones-listado').html( div );

//  Seleccion una region del listao
    mesa_nueva_regiones_listado_marcar( 3013 );
}

//  Seleccion una region del listao
function mesa_nueva_regiones_listado_marcar( id )
{
//  Quitar la seleccion del listado
    $( '#mesa-regiones-listado .regiones-listado-box' ).each(function()
    {
        $( this ).removeClass( 'on' );
    });

//  Marcar región seleccionada
    $( '#region-listado-id-' + id ).addClass( 'on' );

//  Obtener valores de la región
    let region_id = id;
    let region_nombre = $( '#region-listado-id-' + id + ' .nombre' ).text();

//  Asignar los valores a la Mesa
    mesa_zona           =   region_id;
    mesa_zona_titulo    =   region_nombre;
}

//  Almacenar información de la Zona seleccionada
function mesa_nueva_zona( id , nombre )
{
    mesa_zona           =   id;
    mesa_zona_titulo    =   nombre;
}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//  Crear funcionalidad autocompletar
function mesa_autocompletar_comunas()
{
//  Crear objeto autocompletar
    let options = {
        data: objeto_comunas,
        getValue: "n",
        list: {
            maxNumberOfElements: 5,
            match: {
                enabled: true
            }
        },
        template: {
            type: "custom",
            method: function(value, objeto)
            {
            //  Crear div con el resultado
                let div     =   `<div class="box">
                                    ${value}
                                </div>`;

            //  Enviar resultado a la UI
                return div;
            }
        }
    };

//  Asignar funcionalidad
    $("#mesa_comuna").easyAutocomplete(options);
}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//  Mostrar detalles de una Mesa
function mesa_detalles( id )
{
//  Almacenar ID de la mesa
    mesa_id     =   id;

//  Obtener Diccionario de Gobernadores
    $.getJSON( path_app + '/mesas/detalles/' + id , function( objeto )
    {
    //  Almacenar Tipo de mesa
        mesa_tipo   =   objeto.mesa.mesa_tipo;

    //  Almacenar datos generales
        mesa_zona               =   objeto.mesa.mesa_zona;
        mesa_zona_titulo        =   objeto.mesa.mesa_zona_titulo;
        mesa_usuario            =   objeto.mesa.usuario_nombre;

    //  Asignar Dueño de la Mesa
        marcarListadoOpcion( 'usuario_id' , objeto.mesa.usuario_id );

    //	Marcar Estado de la Mesa
        marcarOpcion( 'mesa_estado' , objeto.mesa.mesa_estado );

    //  Almacenar el Estado de la Mesa
        mesa_estado_guardado = objeto.mesa.mesa_estado;

    //  Generar tipo de elección    
        let mesa_tipo_titulo;

    //  Asignar tipo de elección
        switch( mesa_tipo )
        {
            case 'G':
                mesa_tipo_titulo        =   'ELECCIÓN DE GOBERNADORES';
            break;
            case 'A':
                mesa_tipo_titulo        =   'ELECCIÓN DE ALCALDES';
            break;
            case 'P':
                mesa_tipo_titulo        =   'ELECCIÓN DE PLEBISCITO';
            break;
        }

    //  Asignar el titulo a la mesa
        $('#livebox-mesa-titulo').html( mesa_tipo_titulo );

    //  Asignar la comuna de votación
        if( objeto.mesa.mesa_comuna == '' )
        {
            $('#mesa_comuna').val( mesa_nueva_comuna );
        }
        else
        {
            $('#mesa_comuna').val( objeto.mesa.mesa_comuna );
        }
        
    //  Asignar el Local de votación
        $('#mesa_local').val( objeto.mesa.mesa_local );

    //  Asignar el Numero de Mesa
        $('#mesa_numero').val( objeto.mesa.mesa_numero );

    //  Vaciar contenedor
        $('#candidatos-lista').html('');

    //  Asignar el Numero de Mesa
        $('#livebox_mesa_id').html(`<span>${objeto.mesa.mesa_id}</span>`);

    //  Vaciar el Objeto Candidatos
        mesa_candidatos     =   [];

    //  Crear Objeto con los candidatos
        objeto_candidatos = [];

    //  Validar que existan candidatos
        if( objeto.candidatos )
        {

        //  Asignar los Candidatos
            $.each( objeto.candidatos , function( i, candidato )
            {
            //  Agregar al objeto de autocompletar
                objeto_candidatos.push( { i: Number(candidato.candidato_id) , n: String(candidato.candidato_nombre) } );

            /*

                MODO SIN EDICIÓN

            //  Crear Div candidato
                let div     =   `<div class="candidato candidato-buscar-item candidato-hover-brightness" id="candidato-${candidato.candidato_id}">
                                    <div class="candidato-nombre">
                                        <input disabled="disabled" id="candidato_nombres_${candidato.candidato_id}" type="text" autocomplete="off" class="numerico box-shadow-light bordes-radius" placeholder="" value="${candidato.candidato_nombres}"></input>
                                    </div>
                                    <div class="candidato-votos"><input candidato="${candidato.candidato_id}" id="voto-${candidato.voto_id}" type="text" autocomplete="off" class="mesa_valor_numerico numerico box-shadow-light bordes-radius align-right" maxlength="3" placeholder="999" value="${candidato.voto_total}" /></div>
                                    <div class="candidato-guardar"><i class="fas fa-check-circle tipsy-s" title="Guardar Voto" onclick="mesa_votos(${candidato.voto_id},'g',${candidato.candidato_id});"></i></div>
                                    <div class="candidato-sumar"><i class="fas fa-plus-circle tipsy-s" title="Sumar un Voto" onclick="mesa_votos(${candidato.voto_id},'s',${candidato.candidato_id});"></i></div>
                                    <div class="candidato-restar"><i class="fas fa-minus-circle tipsy-s" title="Restar un Voto" onclick="mesa_votos(${candidato.voto_id},'r',${candidato.candidato_id});"></i></div>
                                    <div id="candidato_voto_bloqueado_${candidato.candidato_id}" class="candidato-bloqueado"></div>
                                </div>`;

            */

                /*

                MODO CONSTITUYENTES

                */

            //  Crear Div candidato
                let div     =   `<div class="candidato candidato-buscar-item candidato-hover-brightness" id="candidato-${candidato.candidato_id}">
                                    <div class="candidato-nombre">
                                        <div class="candidato-nombre-historico tipsy-sw" title="<h2>Nombre Completo</h2><p>${candidato.candidato_nombre}</p>"><i class="fas fa-bookmark"></i></div>
                                        <input id="candidato_nombres_${candidato.candidato_id}" type="text" autocomplete="off" class="candidato-nombres box-shadow-light bordes-radius" placeholder="" value="${candidato.candidato_nombres}"></input>
                                        <input id="candidato_apellidos_${candidato.candidato_id}" type="text" autocomplete="off" class="candidato-apellidos box-shadow-light bordes-radius" placeholder="" value="${candidato.candidato_apellidos}"></input>
                                        <div class="candidato-nombre-guardar" onclick="mesa_candidato_nombre(${candidato.candidato_id});"><i class="fas fa-check-circle"></i></div>
                                    </div>
                                    <div class="candidato-votos"><input candidato="${candidato.candidato_id}" id="voto-${candidato.voto_id}" type="text" autocomplete="off" class="mesa_valor_numerico numerico box-shadow-light bordes-radius align-right" maxlength="3" placeholder="999" value="${candidato.voto_total}" /></div>
                                    <div class="candidato-guardar"><i class="fas fa-check-circle tipsy-s" title="Guardar Voto" onclick="mesa_votos(${candidato.voto_id},'g',${candidato.candidato_id});"></i></div>
                                    <div class="candidato-sumar"><i class="fas fa-plus-circle tipsy-s" title="Sumar un Voto" onclick="mesa_votos(${candidato.voto_id},'s',${candidato.candidato_id});"></i></div>
                                    <div class="candidato-restar"><i class="fas fa-minus-circle tipsy-s" title="Restar un Voto" onclick="mesa_votos(${candidato.voto_id},'r',${candidato.candidato_id});"></i></div>
                                    <div id="candidato_voto_bloqueado_${candidato.candidato_id}" class="candidato-bloqueado"></div>
                                </div>`;

            /*

            //  Validar Lista de los candidatos
                if( candidato.candidato_lista == 'A')
                {
                //  Asignar al contenedor
                    $('#candidatos-lista-a').append(div);
                }
                else
                {
                //  Asignar al contenedor
                    $('#candidatos-lista-b').append(div);
                }

            */

                $('#candidatos-lista').append(div);

            //  Agregar al objeto de autocompletar
                mesa_candidatos.push( { i: candidato.voto_id , n: candidato.candidato_nombre } );
            });

        }
        else
        {

            for (let i = 1; i <= 15; i++)
            {

                //  Crear Div candidato
                let div     =   `<div class="candidato candidato-buscar-item candidato-hover-brightness" id="candidato-${i}">
                    <div class="candidato-nombre">
                        <div class="candidato-nombre-historico tipsy-sw" title="<h2>Nombre Completo</h2><p>${i}</p>"><i class="fas fa-bookmark"></i></div>
                        <input id="candidato_nombres_${i}" type="text" autocomplete="off" class="candidato-nombres box-shadow-light bordes-radius" placeholder="" value="NOMBRE ${i}"></input>
                        <input id="candidato_apellidos_${i}" type="text" autocomplete="off" class="candidato-apellidos box-shadow-light bordes-radius" placeholder="" value="APELLIDO ${i}"></input>
                        <div class="candidato-nombre-guardar" onclick="mesa_candidato_nombre(${i});"><i class="fas fa-check-circle"></i></div>
                    </div>
                    <div class="candidato-votos"><input candidato="${i}" id="voto-${i}" type="text" autocomplete="off" class="mesa_valor_numerico numerico box-shadow-light bordes-radius align-right" maxlength="3" placeholder="999" value="${i + 2}" /></div>
                    <div class="candidato-guardar"><i class="fas fa-check-circle tipsy-s" title="Guardar Voto" onclick="mesa_votos(${i});"></i></div>
                    <div class="candidato-sumar"><i class="fas fa-plus-circle tipsy-s" title="Sumar un Voto" onclick="mesa_votos(${i});"></i></div>
                    <div class="candidato-restar"><i class="fas fa-minus-circle tipsy-s" title="Restar un Voto" onclick="mesa_votos(${i});"></i></div>
                    <div id="candidato_voto_bloqueado_${i}" class="candidato-bloqueado"></div>
                </div>`;

                $('#candidatos-lista').append(div);

            }

        }

    //  Estado acciones votacion
        $('.mesa_valor_numerico').keyup(function (event)
        {
            const candidato_id = $(this).attr('candidato')
            estado_votos_candidato( candidato_id , 'off' );
        });

    //	Recalcular Posición Funcionalidad Livebox
        liveboxPosicionar();

        // TAMAÑO PLEBISCITO : 480
        // TAMAÑO CANDIDATOS : 740
        // TAMAÑO CONSTITUYENTES : 650

    //  Cambiar la dimensión
        liveboxAncho('mesa-detalles' , 700 );

    //	Abrir Funcionalidad Livebox
        liveboxAbrir('mesa-detalles');

    //	Quitar Usabilidad Cargando
        liveboxCargandoCompleto();

    //  Habilitar autocompletar en las comunas
    //  mesa_autocompletar_comunas();

    //  Buscar un candidato en el listado
        mesa_detalles_buscar_candidato();

    //  Asignar funcionalidad Tootip
        $('.tipsy-sw').tipsy({gravity: "sw" , title: function() { return this.getAttribute('original-title'); } });
        $('.tipsy-s').tipsy({gravity: "s" , title: function() { return this.getAttribute('original-title'); } });

        $('.numerico').keyup(function (event)
        {
            if (this.value.match(/[^0-9]/g))
            {
                this.value = this.value.replace(/[^0-9]/g, '');
            }
        });

        $('#mesa_local').keyup(function (event)
        {
            mesa_local_largo();
        });

        mesa_local_largo();
    });
}

//  Estado de los botones de votacion
function estado_votos_candidato( candidato , estado )
{
    if( estado == 'on')
    {
        const candidato_voto_bloqueado = document.getElementById('candidato_voto_bloqueado_' + candidato)
        candidato_voto_bloqueado.style.display = 'none'
    }
    
    if(estado == 'off')
    {
        const candidato_voto_bloqueado = document.getElementById('candidato_voto_bloqueado_' + candidato)
        candidato_voto_bloqueado.style.display = 'block'
    }
}

//  Limitar el nombre del local
function mesa_local_largo()
{
//  Obtener los contenedores
    const mesa_local = document.getElementById("mesa_local")
    const mesa_local_largo = document.getElementById("mesa_local_largo")

    const maximo = 25
    const caracteres = mesa_local.value.length
    let caracteres_restantes = maximo - caracteres;

    mesa_local_largo.innerHTML = `<b>${caracteres_restantes} ${ caracteres_restantes == 1 ? 'Caracter' : 'Caracteres' }</b> disponibles`
}

//  Guardar detalles de una Mesa
function mesa_detalles_confirmar()
{
//	Mostrar Usabilidad Cargando
    liveboxCargando();

//  Post Data
    $.post( path_app + '/mesas/guardar/' ,
    {
        mesa_id                     :   mesa_id,
        mesa_estado                 :   document.getElementById("mesa_estado").value,
        usuario_id                  :   document.getElementById("usuario_id").value,
        mesa_comuna                 :   document.getElementById("mesa_comuna").value,
        mesa_local                  :   document.getElementById("mesa_local").value,
        mesa_numero                 :   document.getElementById("mesa_numero").value
    })
    .done(function( respuesta )
    {
        let mesa_estado                 =   document.getElementById("mesa_estado").value;
        let mesa_comuna                 =   document.getElementById("mesa_comuna").value;
        let mesa_local                  =   document.getElementById("mesa_local").value;
        let mesa_numero                 =   document.getElementById("mesa_numero").value;

        let mesa_tipo_titulo            =   '';
        let mesa_tipo_icono             =   '';

    //  Asignar tipo de elección
        switch( mesa_tipo )
        {
            case 'G':
                mesa_tipo_titulo        =   '🟡&nbsp;&nbsp;&nbsp;GOBERNADORES';
                mesa_tipo_icono         =   'fa-sticky-note';
            break;
            case 'A':
                mesa_tipo_titulo        =   '🔴&nbsp;&nbsp;&nbsp;ALCALDES';
                mesa_tipo_icono         =   'fa-sticky-note';
            break;
            case 'P':
                mesa_tipo_titulo        =   '🔵&nbsp;&nbsp;&nbsp;PLEBISCITO';
                mesa_tipo_icono         =   'fa-sticky-note';
            break;
        }

        let mesa_numero_out = '';

        if(mesa_numero)
        {
            mesa_numero_out = mesa_numero;
        }
        else
        {
            mesa_numero_out = '-&nbsp;&nbsp;&nbsp;-&nbsp;&nbsp;&nbsp;-';
        }

    //  Crear Objeto
        let objeto  =   `<article class="filtro-mesa mesa estado-${mesa_estado} ${mesa_tipo} bg-blanco box-shadow bordes-radius gris" id="mesa-${mesa_id}" data="${mesa_id}">
                            <div class="opciones bordes-radius box-shadow-light">
                                <i class="fas fa-highlighter tipsy-top" title="<h2>Modificar Mesa</h2><p>Podrás modificar la información de la Mesa y los Votos asociados.</p>" onclick="mesa_detalles( ${mesa_id} );"></i>
                                <i class="fas fa-copy tipsy-top invisible" title="<h2>Duplicar Mesa</h2><p>Podrás duplicar la información de la Mesa y los Votos asociados.</p>" onclick="duplicarMesa( ${mesa_id} );"></i>
                                <i class="fas fa-trash-alt tipsy-top"  title="<h2>Eliminar Mesa</h2><p>La Mesa será eliminada junto a toda la información relacionada.</p>" onclick="mesa_eliminar( ${mesa_id} );"></i>
                            </div>
                            <header>
                                <div onclick="mesaDestacada( ${mesa_id} );" class="estado estado-0 box-shadow-light" id="${mesa_id}">
                                    <div></div>
                                </div>
                                <h2><i class="fas fa-passport"></i> ${mesa_id}</h2>
                                <h1 class="line-1" id="${mesa_id}_mesa_usuario"><i class="fas fa-user"></i> ${mesa_usuario}</h1>
                                <div class="tipo">${mesa_tipo_titulo}</div>
                                <div class="zona">${mesa_zona_titulo}</div>
                                <h3 class="line-1">${mesa_local}</h3>
                                <h4 class="line-1">${mesa_numero_out}</h4>
                                <h5 class="line-1"><i class="fas fa-globe-americas"></i> ${mesa_comuna}</h5>
                                <h6 class="line-1"><i class="fas fa-clock"></i> Actualizado hace segundos</h6>
                            </header>
                        </article>`;

    //  Eliminar el Objeto del DOM
        $('#mesa-' + mesa_id).remove();

    //  Agregar el Objeto al DOM
        $('#mesas').prepend(objeto);

    //	Quitar Usabilidad Cargando
        liveboxCargandoCompleto();

    //  Mesa comparar el estado guardado
        if( mesa_estado != mesa_estado_guardado )
        {
        //	Construir Variable para enviar a PubNub
            let pubnub       	=
            {
                'mesa_id' : mesa_id,
                'mesa_tipo' : mesa_tipo,
                'accion' : 'recargar'
            }

        //	Enviar Notificación a PubNub
            enviarPubNub( pubnub );

        //  Almacenar Nuevo estado
            mesa_estado_guardado = mesa_estado;
        }
        else
        {
            console.log('Estado igual');
        }
    });
}

//  Buscar un candidato en el listado
function mesa_detalles_buscar_candidato()   
{
//  Funcionalidad al input
    const candidato_filtro = document.getElementById('candidato_nombre');
    candidato_filtro.value = '';

//  Asignar input
    candidato_filtro.addEventListener('keypress' , (e) =>
    {
        $('.candidato-buscar-item').fadeOut(0);
    })

//  Crear objeto autocompletar
    let options = {
        data: objeto_candidatos,
        getValue: "n",
    //  requestDelay: 250,
        list: {
            maxNumberOfElements: 5,
            match: {
                enabled: true
            }
        },
        template: {
            type: "custom",
            method: function(value, objeto)
            {
                $('#candidato-' + objeto.i).fadeIn(0);
            }
        }
    };

//  Asignar funcionalidad
    $("#candidato_nombre").easyAutocomplete(options);

    $('#eac-container-candidato_nombre').css('visibility','hidden');
    $('#eac-container-candidato_nombre').css('opacity','0');
}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//  Actualizar el Nombre de un candidato
function mesa_candidato_nombre( id )
{
//	Mostrar Usabilidad Cargando
    liveboxCargando();

//  Post Data
    $.post( path_app + '/mesas/candidato/guardar/' ,
    {
        candidato_id                :   id,
        candidato_nombres           :   document.getElementById( 'candidato_nombres_' + id ).value,
        candidato_apellidos         :   document.getElementById( 'candidato_apellidos_' + id ).value
    })
    .done(function( respuesta )
    {
    //	Quitar Usabilidad Crgando
        liveboxCargandoCompleto();
    });
}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//  Asignar un Voto al Candidato
function mesa_votos( objeto , accion , candidato )
{
//	Mostrar Usabilidad Cargando
    liveboxCargando();

//	Obtener Votos Actuales
    var valor	=	Number( $( "#voto-" + objeto ).val() );

//	Guardar Votos
    if( accion == "g" )
    {
        var resultado	=	valor;

    //  Estado de los botones de votacion
        estado_votos_candidato( candidato , 'on' );
    }

//	Sumar Votos
    if( accion == "s" )
    {
        if( valor == 999 )
        {
            var resultado	=	valor;
        }
        else
        {
            var resultado	=	valor + 1;
        }
    }
    
//	Restar Votos
    if( accion == "r" )
    {
        if( valor == 0 )
        {
            var resultado	=	valor;
        }
        else
        {
            var resultado	=	valor - 1;
        }
    }
    
//	Actualizar valor en el Input
    $( "#voto-" + objeto ).val( resultado );

    let voto_id                     =   objeto;
    let voto_total                  =   resultado;

//  Post Data
    $.post( path_app + '/mesas/voto/' ,
    {
        mesa_id                     :   mesa_id,
        voto_id                     :   voto_id,
        voto_total                  :   voto_total
    })
    .done(function( respuesta )
    {
    //  Construir el Objeto con los votos de los candidatos
        $.each( mesa_candidatos , function( i , candidato )
        {
        //  Obtener el voto asociado
            let voto    =   $("#voto-" + candidato.i).val();

        //  Almacenar el voto en el objeto
            mesa_candidatos[ i ]    =   { i: candidato.i , v: voto };
        });

    //	Construir Variable para enviar a PubNub
        let pubnub       	=
        {
            'accion'		:	'voto',
            'accion_voto'   :   accion,
            'tipo'          :   mesa_tipo,
            'mesa'          :	mesa_id,
            'id'            :   voto_id,
            'valor'         :	voto_total,
            'candidato'     :   candidato
        }

    //	Enviar Notificación a PubNub
        enviarPubNub( pubnub );

    //	Asignar tiempo de espera
        setTimeout(function()
        {
        //	Quitar Usabilidad Cargando
            liveboxCargandoCompleto();
        }, 500 );
    });
}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//  Mesa Eliminar
function mesa_eliminar( id )
{
//	Abrir Funcionalidad Livebox
    liveboxAbrir('mesa-eliminar');

//  Almacenar ID de la mesa
    mesa_id     =   id;
}

//  Mesa Eliminar Confirmar
function mesa_eliminar_confirmar()
{
//	Mostrar Usabilidad Cargando
    liveboxCargando();

//  Post Data
    $.post( path_app + '/mesas/eliminar/' ,
    {
        mesa_id                     :   mesa_id
    })
    .done(function( respuesta )
    {
    //  Eliminar Objeto del DOM
        $('#mesa-' + mesa_id).remove();

    //	Quitar Usabilidad Cargando
        liveboxCargandoCompleto();

    //	Cerrar Funcionalidad Livebox
        liveboxCerrar();

    //	Construir Variable para enviar a PubNub
        let pubnub       	=
        {
            'accion'		:	'recargar'
        }

    //	Enviar Notificación a PubNub
        enviarPubNub( pubnub );
    });
}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Funcionalidad para elegir una Opcion
function mesa_cambiar_estado( ID , OBJETO )
{
//	Quitar clase de selección
    $( "#form-opcion-" + ID + " > div" ).each(function()
    {
        $( this ).removeClass( "on" );
    });
    
//	Agregar clase de selección
    $( "#" + ID + "-" + OBJETO ).addClass( "on" );
    
//	Almacenar opción seleccionada
    $( "#" + ID ).val( OBJETO );

//  Aplicar Cambios
    mesa_detalles_confirmar();
}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Seleccionar que votos Mostrar
function mesa_filtrar( opcion )
{
//  Quitar opcion destacada
    $("#opcion-voto-G").removeClass("activo").addClass("nuevo");
    $("#opcion-voto-A").removeClass("activo").addClass("nuevo");

//  Validar el estado del filtro
    if( mesa_filtro == opcion )
    {
    //	Almacenar Opcion en Cookie
        $.cookie('vav_mesas_votos', 0 , { expires: 7, path: '/' });

    //  Mostrar todas las mesas
        $(".filtro-mesa").css("display","block");

    //  Reiniciar Filtro
        mesa_filtro     =   0;
    }
    else
    {
    //	Almacenar Opcion en Cookie
        $.cookie('vav_mesas_votos', opcion , { expires: 7, path: '/' });
        
    //  Ocultar todas las mesas
        $(".filtro-mesa").css("display","none");

    //  Gobernadores
        if( opcion == 'G' )
        {
            $(".G").css("display","block");

        //  Marcar opcion destacada
            $("#opcion-voto-G").removeClass("nuevo").addClass("activo");
        }

    //  Alcaldes
        if( opcion == 'A' )
        {
            $(".A").css("display","block");

        //  Marcar opcion destacada
            $("#opcion-voto-A").removeClass("nuevo").addClass("activo");
        }

    //  Almacenar Filtro
        mesa_filtro     =   opcion;
    }
}

//  Quitar los Filtros de Busqueda
function limpiarFiltro()
{
    $('.candidato-buscar-item').fadeIn(0);

//  Funcionalidad al input
    const candidato_filtro = document.getElementById('candidato_nombre');
    candidato_filtro.value = '';
}

//  Cambiar el Estado de consolidados
function estadoConsolidados( estado )
{
//  Obtener los elementos
    const consolidados_on = document.getElementById('consolidados-estado-on');
    const consolidados_of = document.getElementById('consolidados-estado-of');

    const consolidado_tipo_cookie = $.cookie('consolidado_tipo');
    const consolidado_zona_cookie = $.cookie('consolidado_zona');

//  Validar estado reciente
    if( estado_consolidados == estado )
    {

    }
    else
    {
        if( estado_consolidados_animacion == false && consolidado_zona_cookie != undefined )
        {
        //  Almacenar el estado de la accion
            estado_consolidados = estado

        //  Validar los estados
            if( estado == 'on' )
            {
                consolidados_of.classList.remove('on')
                consolidados_of.classList.add('of')

                consolidados_on.classList.remove('of')
                consolidados_on.classList.add('on')
            }
            else
            {
                consolidados_of.classList.remove('of')
                consolidados_of.classList.add('on')

                consolidados_on.classList.remove('on')
                consolidados_on.classList.add('of')
            }

            consolidados_render_estado(estado);

            consolidados_on.style.opacity = 0.5
            consolidados_of.style.opacity = 0.5

        //	Construir Variable para enviar a PubNub
            let pubnub       	=
            {
                'accion'		:	'cons_estado',
                'estado'        :	estado,
                'tipo'          :   consolidado_tipo_cookie,
                'zona'          :   consolidado_zona_cookie
            }

        //	Enviar Notificación a PubNub
            enviarPubNub( pubnub );

            estado_consolidados_animacion = true

            setTimeout(function()
            {
                consolidados_on.style.opacity = 1
                consolidados_of.style.opacity = 1

                estado_consolidados_animacion = false
            }, 1500);
        }
    }

//	Almacenar el Estado en Cookie
    $.cookie('vav_cons_estado', estado , { expires: 7, path: '/' });
}

//  Cambiar el Estado de consolidados
function posicionConsolidados( posicion )
{
//  Obtener los elementos
    const consolidados_l = document.getElementById('consolidados-posicion-l');
    const consolidados_r = document.getElementById('consolidados-posicion-r');

//  Validar estado reciente
    if( posicion_consolidados == posicion )
    {

    }
    else
    {
    //  Almacenar el estado de la accion
        posicion_consolidados = posicion

    //  Validar los estados
        if( posicion == 'r' )
        {
            consolidados_l.classList.remove('on')
            consolidados_l.classList.add('of')

            consolidados_r.classList.remove('of')
            consolidados_r.classList.add('on')
        }
        else
        {
            consolidados_l.classList.remove('of')
            consolidados_l.classList.add('on')

            consolidados_r.classList.remove('on')
            consolidados_r.classList.add('of')
        }

    //	Construir Variable para enviar a PubNub
        let pubnub       	=
        {
            'accion'		:	'cons_posicion',
            'posicion'      :	posicion
        }

    //	Enviar Notificación a PubNub
        enviarPubNub( pubnub );
    }

//	Almacenar la Posicion en Cookie
    $.cookie('vav_cons_posicion', posicion , { expires: 7, path: '/' });
}

//  Cambiar el Estado de consolidados
function estadoConsolidadosActual( estado )
{
//  Obtener los elementos
    const consolidados_on = document.getElementById('consolidados-estado-on');
    const consolidados_of = document.getElementById('consolidados-estado-of');

//  Validar que exista el elemento
    if( consolidados_on != null )
    {
    //  Almacenar el estado de la accion
        estado_consolidados = estado
        
        consolidados_on.style.opacity = 0.5
        consolidados_of.style.opacity = 0.5

        setTimeout(function()
        {
            consolidados_on.style.opacity = 1
            consolidados_of.style.opacity = 1

            estado_consolidados_animacion = false

        //  Validar los estados
            if( estado == 'on' )
            {
                consolidados_of.classList.remove('on')
                consolidados_of.classList.add('of')

                consolidados_on.classList.remove('of')
                consolidados_on.classList.add('on')
            }
            else
            {
                consolidados_of.classList.remove('of')
                consolidados_of.classList.add('on')

                consolidados_on.classList.remove('on')
                consolidados_on.classList.add('of')
            }

            consolidados_render_estado(estado);

        //	Almacenar el Estado en Cookie
            $.cookie('vav_cons_estado', estado , { expires: 7, path: '/' });

        }, 1500);
    }
}

//  Cambiar el Estado de consolidados
function posicionConsolidadosActual( posicion )
{
//  Obtener los elementos
    const consolidados_l = document.getElementById('consolidados-posicion-l');
    const consolidados_r = document.getElementById('consolidados-posicion-r');

//  Almacenar el estado de la accion
    posicion_consolidados = posicion

//  Validar que exista el elemento
    if( consolidados_l != null )
    {
    //  Validar los estados
        if( posicion == 'r' )
        {
            consolidados_l.classList.remove('on')
            consolidados_l.classList.add('of')

            consolidados_r.classList.remove('of')
            consolidados_r.classList.add('on')
        }
        else
        {
            consolidados_l.classList.remove('of')
            consolidados_l.classList.add('on')

            consolidados_r.classList.remove('on')
            consolidados_r.classList.add('of')
        }
    }
}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

