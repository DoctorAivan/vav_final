let consolidado_tipo = ''
let consolidado_zona = 0
let consolidado_zona_nombre = ''

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

// Iniciar al cargar
$(function()
{
    consolidados_render();

    consolidado_tipo = $.cookie('consolidado_tipo')
    consolidado_zona = $.cookie('consolidado_zona')
});

// Actualizar información del consolidado
function consolidados_render()
{
//  Obtener Elementos del DOM
    const consolidados_render_tipo = document.getElementById('consolidados-render-tipo')
    const consolidados_render_zona = document.getElementById('consolidados-render-zona')

//  Obtener Cookies
    const consolidados_tipo = $.cookie('consolidado_tipo')
    const consolidados_zona_nombre = $.cookie('consolidado_zona_nombre')

//  Validar Tipo
    if( consolidados_tipo == 'G' )
    {
        consolidados_render_tipo.innerHTML = '🟡&nbsp;&nbsp;GOBERNADORES';
    }
    else if( consolidados_tipo == 'A' )
    {
        consolidados_render_tipo.innerHTML = '🔴&nbsp;&nbsp;ALCALDES';
    }
    else
    {
        consolidados_render_tipo.innerHTML = '🔵&nbsp;&nbsp;VACIO';
    }

//  Validar Zona Nombre
    if( consolidados_zona_nombre )
    {
        consolidados_render_zona.innerHTML = consolidados_zona_nombre
    }
    else
    {
        consolidados_render_zona.innerHTML = 'ASIGNAR UNA ZONA'
    }
}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

// Consolidados Asignar
function consolidados_asignar()
{
    if( estado_consolidados != "on" )
    {

    }


//  Cambiar la dimensión
    liveboxAncho('consolidados' , 500 );

//	Abrir Funcionalidad Livebox
    liveboxAbrir('consolidados');

//  Obtener Tipo
    const consolidados_tipo_cookie = $.cookie('consolidado_tipo')

//  Marcar Pacto por Defecto
    consolidados_tipo( consolidados_tipo_cookie ? consolidados_tipo_cookie : 'G' );

//  Limpiar input comunas
    const input_comunas = document.getElementById('mesa_consolidado_comunas')
    input_comunas.value = ''

//  Funcionalidad Botones nueva mesa
    const mensa_nueva_of = document.getElementById('mesa-nueva-of')
    const mensa_nueva_on = document.getElementById('mesa-nueva-on')

//  Estado de los botones de accion
    mensa_nueva_of.style.display = 'block';
    mensa_nueva_on.style.display = 'none';
}

// Consolidados Tipo
function consolidados_tipo( tipo )
{
//  Quitar seleccion
    $( '#consolidado-tipo div' ).each(function()
    {
        $( this ).removeClass( 'on' );
    });

//  Destacar Opción
    $( '#consolidado-tipo-' + tipo ).addClass( 'on' );

//  Almacenar tipo de Mesa
    consolidado_tipo       =   tipo;

//  Tipo de mesa
    if( tipo == 'G' )
    {
        consolidados_autocompletar_region();
    }
    else
    {
        consolidados_autocompletar_comunas();
    }

    //  Funcionalidad Botones nueva mesa
    const mensa_nueva_of = document.getElementById('mesa-nueva-of')
    const mensa_nueva_on = document.getElementById('mesa-nueva-on')

    //  Estado de los botones
    mensa_nueva_of.style.display = 'block';
    mensa_nueva_on.style.display = 'none';
}

// Consolidados Guardar Valores
function consolidados_guardar()
{
//  Actualizar los valores de las cookies
    $.cookie('consolidado_tipo', consolidado_tipo , { expires: 7, path: '/' });
    $.cookie('consolidado_zona', consolidado_zona , { expires: 7, path: '/' });
    $.cookie('consolidado_zona_nombre', consolidado_zona_nombre , { expires: 7, path: '/' });

//  Actualizar el DOM
    consolidados_render();
    liveboxCerrar();
}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

// Funcionalidad autocompletar
function consolidados_autocompletar_comunas()
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
                let div     =   `<div class="box" onClick="consolidados_autocompletar_comunas_asignar(${objeto.id})">
                                    <div class="child">${value}</div>
                                    <div class="parent">${region.nombre}</div>
                                </div>`;

            //  Enviar resultado a la UI
                return div;
            }
        }
    };

//  Asignar funcionalidad
    $("#mesa_consolidado_comunas").easyAutocomplete(options);
}

// Funcionalidad autocompletar
function consolidados_autocompletar_region()
{
//  Crear objeto autocompletar
    let options = {
        data: objeto_regiones,
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
            //  Crear div con el resultado
                let div     =   `<div class="box" onClick="consolidados_autocompletar_region_asignar(${objeto.id})">
                                    <div class="child">${value}</div>
                                </div>`;

            //  Enviar resultado a la UI
                return div;
            }
        }
    };

//  Asignar funcionalidad
    $("#mesa_consolidado_comunas").easyAutocomplete(options);
}

// Funcionalidad autocompletar asignar
function consolidados_autocompletar_region_asignar( id )
{
//  Obtener la Circunscripcion de la Comuna
    let region = objeto_regiones.find( obj => obj.id === id );

//  Tipo Zona Gobernador
    consolidado_zona = region.id;
    consolidado_zona_nombre = region.nombre;

//  Funcionalidad Botones nueva mesa
    const mensa_nueva_of = document.getElementById('mesa-nueva-of')
    const mensa_nueva_on = document.getElementById('mesa-nueva-on')

//  Estado de los botones
    mensa_nueva_of.style.display = 'none';
    mensa_nueva_on.style.display = 'block';
}

// Funcionalidad autocompletar asignar
function consolidados_autocompletar_comunas_asignar( id )
{
//  Obtener información de la Comuna
    let comuna = objeto_comunas.find( obj => obj.id === id );

//  Tipo Zona Alcalde
    consolidado_zona = comuna.id;
    consolidado_zona_nombre = comuna.nombre;

//  Funcionalidad Botones nueva mesa
    const mensa_nueva_of = document.getElementById('mesa-nueva-of')
    const mensa_nueva_on = document.getElementById('mesa-nueva-on')

//  Estado de los botones
    mensa_nueva_of.style.display = 'none';
    mensa_nueva_on.style.display = 'block';
}

// Validar el Estado de la accion
function consolidados_render_estado(estado)
{
    /*

    const consolidados_render = document.getElementById('consolidados-render');
    const consolidados_render_icon = document.getElementById('consolidados-render-icon');

//  Validar los estados
    if( estado == 'on' )
    {
        consolidados_render.style.opacity   =   0.5
        consolidados_render_icon.classList.remove('fa-highlighter')
        consolidados_render_icon.classList.add('fa-lock')
    }
    else
    {
        consolidados_render.style.opacity   =   1
        consolidados_render_icon.classList.remove('fa-lock')
        consolidados_render_icon.classList.add('fa-highlighter')
    }

    */
}