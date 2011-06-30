unit KolOGL12;

{----------------------------------------------------------------------------------------------------------------------

  This is an interface unit for the use of OpenGL from within Delphi and contains
  the translations of gl.h, glu.h as well as some support functions.
  OpenGL12.pas contains bug fixes and enhancements of Delphi's and other translations
  as well as support for extensions.

----------------------------------------------------------------------------------------------------------------------
 This translation is based on OpenGL12.pas source:
 OpenGL12.pas:  Contact: public@lischke-online.de
                Last change: 17. February 2001
                Version: 1.2.4

----------------------------------------------------------------------------------------------------------------------
Version 1.2.4 :) 4.07.2001 by Vyacheslav A. Gavrik

 mailto: slag@mail.primorye.ru

 All modifications applyed for minimization code.

 [-] All Code Translated for using with KOL
        KOL - Key Objects Library (C) 2000 by Kladov Vladimir.
        mailto: bonanzas@xcl.cjb.net
        Home: http://www.angelfire.com/home/kol/index.htm
 [-] All base OGL methods translated for auto initialization code
 [+] procedure InitGLExtensions;
        This procedure allow call ReadExtensions from ActivateRenderingContext
        if a new pixel format is used, but you can safely call it from where you want
        to actualize those values (under the condition that a rendering context MUST be active).
 [-] All variables for checking availability of Extensions
        - translated to Functions.

----------------------------------------------------------------------------------------------------------------------

 function InitOpenGL: Boolean;
   Needed to load the OpenGL DLLs and all addresses of the standard functions.
   In case OpenGL is already initialized this function does nothing. No error
   is raised, if something goes wrong, but you need to inspect the result in order
   to know if all went okay.
   RESULT: True if successful or already loaded, False otherwise

 function InitOpenGLFromLibrary(GL_Name, GLU_Name: String): Boolean;
   Same as InitOpenGL, but you can specify specific DLLs. Useful if you want to
   use different DLLs then those of Windows. This function closes eventually
   loaded DLLs before it tries to open the newly given.
   RESULT: True if successful, False otherwise

 procedure CloseOpenGL;
   Unloads the OpenGL DLLs and sets all function addresses to nil, including
   extensions. You can load and unload the DLLs as often as you like.

 function  CreateRenderingContext(DC: HDC; Options: TRCOptions; ColorBits, StencilBits, AccumBits, AuxBuffers: Integer;
   Layer: Integer): HGLRC;
   Sets up a pixel format and creates a new rendering context depending of the
   given parameters:
     DC          - the device context for which the rc is to be created
     Options     - options for the context, which the application would like to have
                   (it is not guaranteed they will be available)
     ColorBits   - the color depth of the device context (Note: Because of the internal DC handling of the VCL you
                   should avoid using GetDeviceCaps for memory DCs which are members of a TBitmap class.
                   Translate the Pixelformat member instead!)
     StencilBits - requested size of the stencil buffer
     AccumBits   - requested size of the accumulation buffer
     AuxBuffers  - requested number of auxiliary buffers
     Layer       - ID for the layer for which the RC will be created (-1..-15 for underlay planes, 0 for main plane,
                   1..15 for overlay planes)
                   Note: The layer handling is not yet complete as there is very few information
                   available and (until now) no OpenGL implementation with layer support on the low budget market.
                   Hence use 0 (for the main plane) as layer ID.
   RESULT: the newly created context or 0 if setup failed

 procedure ActivateRenderingContext(DC: HDC; RC: HGLRC);
   Makes RC in DC 'current' (wglMakeCurrent(..)) and loads all extension addresses
   and flags if necessary.

 procedure DeactivateRenderingContext;
   Counterpart to ActivateRenderingContext.

 procedure DestroyRenderingContext(RC: HGLRC);
   RC will be destroyed and must be recreated if you want to use it again.

 procedure ReadExtensions;
   Determines which extensions for the current rendering context are available and
   loads their addresses. This procedure is called from ActivateRenderingContext
 * (InitGLExtensions must be called before ActivateRenderingContext)
   if a new pixel format is used, but you can safely call it from where you want
   to actualize those values (under the condition that a rendering context MUST be
   active).

 procedure ReadImplementationProperties;
   Determines other properties of the OpenGL DLL (version, availability of extensions).
   Again, a valid rendering context must be active.

----------------------------------------------------------------------------------------------------------------------


{ ------ Original copyright notice by SGI -----

 Copyright 1996 Silicon Graphics, Inc.
 All Rights Reserved.

 This is UNPUBLISHED PROPRIETARY SOURCE CODE of Silicon Graphics, Inc.;
 the contents of this file may not be disclosed to third parties, copied or
 duplicated in any form, in whole or in part, without the prior written
 permission of Silicon Graphics, Inc.

 RESTRICTED RIGHTS LEGEND:
 Use, duplication or disclosure by the Government is subject to restrictions
 as set forth in subdivision (c)(1)(ii) of the Rights in Technical Data
 and Computer Software clause at DFARS 252.227-7013, and/or in similar or
 successor clauses in the FAR, DOD or NASA FAR Supplement. Unpublished -
 rights reserved under the Copyright Laws of the United States.}


interface

uses        
  Windows, kol, err;

type

  TRCOptions = set of (
    opDoubleBuffered,
    opGDI,
    opStereo);

  TGLenum     = UINT;
  PGLenum     = ^TGLenum;

  TGLboolean  = UCHAR;
  PGLboolean  = ^TGLboolean;

  TGLbitfield = UINT;
  PGLbitfield = ^TGLbitfield;

  TGLbyte     = ShortInt;
  PGLbyte     = ^TGLbyte;

  TGLshort    = SHORT;
  PGLshort    = ^TGLshort;

  TGLint      = Integer;
  PGLint      = ^TGLint;

  TGLsizei    = Integer;
  PGLsizei    = ^TGLsizei;

  TGLubyte    = UCHAR;
  PGLubyte    = ^TGLubyte;

  TGLushort   = Word;
  PGLushort   = ^TGLushort;

  TGLuint     = UINT;
  PGLuint     = ^TGLuint;

  TGLfloat    = Single;
  PGLfloat    = ^TGLfloat;

  TGLclampf   = Single;
  PGLclampf   = ^TGLclampf;

  TGLdouble   = Double;
  PGLdouble   = ^TGLdouble;

  TGLclampd   = Double;
  PGLclampd   = ^TGLclampd;

  PPointer    = ^Pointer;

var
  GL_VERSION_1_0,
  GL_VERSION_1_1,
  GL_VERSION_1_2,
  GLU_VERSION_1_1,
  GLU_VERSION_1_2,
  GLU_VERSION_1_3: Boolean;

const
  // ********** GL generic constants **********

  // errors
  GL_NO_ERROR                                       = 0;
  GL_INVALID_ENUM                                   = $0500;
  GL_INVALID_VALUE                                  = $0501;
  GL_INVALID_OPERATION                              = $0502;
  GL_STACK_OVERFLOW                                 = $0503;
  GL_STACK_UNDERFLOW                                = $0504;
  GL_OUT_OF_MEMORY                                  = $0505;

  // attribute bits
  GL_CURRENT_BIT                                    = $00000001;
  GL_POINT_BIT                                      = $00000002;
  GL_LINE_BIT                                       = $00000004;
  GL_POLYGON_BIT                                    = $00000008;
  GL_POLYGON_STIPPLE_BIT                            = $00000010;
  GL_PIXEL_MODE_BIT                                 = $00000020;
  GL_LIGHTING_BIT                                   = $00000040;
  GL_FOG_BIT                                        = $00000080;
  GL_DEPTH_BUFFER_BIT                               = $00000100;
  GL_ACCUM_BUFFER_BIT                               = $00000200;
  GL_STENCIL_BUFFER_BIT                             = $00000400;
  GL_VIEWPORT_BIT                                   = $00000800;
  GL_TRANSFORM_BIT                                  = $00001000;
  GL_ENABLE_BIT                                     = $00002000;
  GL_COLOR_BUFFER_BIT                               = $00004000;
  GL_HINT_BIT                                       = $00008000;
  GL_EVAL_BIT                                       = $00010000;
  GL_LIST_BIT                                       = $00020000;
  GL_TEXTURE_BIT                                    = $00040000;
  GL_SCISSOR_BIT                                    = $00080000;
  GL_ALL_ATTRIB_BITS                                = $000FFFFF;

  // client attribute bits
  GL_CLIENT_PIXEL_STORE_BIT                         = $00000001;
  GL_CLIENT_VERTEX_ARRAY_BIT                        = $00000002;
  GL_CLIENT_ALL_ATTRIB_BITS                         = $FFFFFFFF;

  // boolean values
  GL_FALSE                                          = 0;
  GL_TRUE                                           = 1;

  // primitives
  GL_POINTS                                         = $0000;
  GL_LINES                                          = $0001;
  GL_LINE_LOOP                                      = $0002;
  GL_LINE_STRIP                                     = $0003;
  GL_TRIANGLES                                      = $0004;
  GL_TRIANGLE_STRIP                                 = $0005;
  GL_TRIANGLE_FAN                                   = $0006;
  GL_QUADS                                          = $0007;
  GL_QUAD_STRIP                                     = $0008;
  GL_POLYGON                                        = $0009;

  // blending
  GL_ZERO                                           = 0;
  GL_ONE                                            = 1;
  GL_SRC_COLOR                                      = $0300;
  GL_ONE_MINUS_SRC_COLOR                            = $0301;
  GL_SRC_ALPHA                                      = $0302;
  GL_ONE_MINUS_SRC_ALPHA                            = $0303;
  GL_DST_ALPHA                                      = $0304;
  GL_ONE_MINUS_DST_ALPHA                            = $0305;
  GL_DST_COLOR                                      = $0306;
  GL_ONE_MINUS_DST_COLOR                            = $0307;
  GL_SRC_ALPHA_SATURATE                             = $0308;
  GL_BLEND_DST                                      = $0BE0;
  GL_BLEND_SRC                                      = $0BE1;
  GL_BLEND                                          = $0BE2;

  // blending (GL 1.2 ARB imaging)
  GL_BLEND_COLOR                                    = $8005;
  GL_CONSTANT_COLOR                                 = $8001;
  GL_ONE_MINUS_CONSTANT_COLOR                       = $8002;
  GL_CONSTANT_ALPHA                                 = $8003;
  GL_ONE_MINUS_CONSTANT_ALPHA                       = $8004;
  GL_FUNC_ADD                                       = $8006;
  GL_MIN                                            = $8007;
  GL_MAX                                            = $8008;
  GL_FUNC_SUBTRACT                                  = $800A;
  GL_FUNC_REVERSE_SUBTRACT                          = $800B;

  // color table GL 1.2 ARB imaging
  GL_COLOR_TABLE                                    = $80D0;
  GL_POST_CONVOLUTION_COLOR_TABLE                   = $80D1;
  GL_POST_COLOR_MATRIX_COLOR_TABLE                  = $80D2;
  GL_PROXY_COLOR_TABLE                              = $80D3;
  GL_PROXY_POST_CONVOLUTION_COLOR_TABLE             = $80D4;
  GL_PROXY_POST_COLOR_MATRIX_COLOR_TABLE            = $80D5;
  GL_COLOR_TABLE_SCALE                              = $80D6;
  GL_COLOR_TABLE_BIAS                               = $80D7;
  GL_COLOR_TABLE_FORMAT                             = $80D8;
  GL_COLOR_TABLE_WIDTH                              = $80D9;
  GL_COLOR_TABLE_RED_SIZE                           = $80DA;
  GL_COLOR_TABLE_GREEN_SIZE                         = $80DB;
  GL_COLOR_TABLE_BLUE_SIZE                          = $80DC;
  GL_COLOR_TABLE_ALPHA_SIZE                         = $80DD;
  GL_COLOR_TABLE_LUMINANCE_SIZE                     = $80DE;
  GL_COLOR_TABLE_INTENSITY_SIZE                     = $80DF;

  // convolutions GL 1.2 ARB imaging
  GL_CONVOLUTION_1D                                 = $8010;
  GL_CONVOLUTION_2D                                 = $8011;
  GL_SEPARABLE_2D                                   = $8012;
  GL_CONVOLUTION_BORDER_MODE                        = $8013;
  GL_CONVOLUTION_FILTER_SCALE                       = $8014;
  GL_CONVOLUTION_FILTER_BIAS                        = $8015;
  GL_REDUCE                                         = $8016;
  GL_CONVOLUTION_FORMAT                             = $8017;
  GL_CONVOLUTION_WIDTH                              = $8018;
  GL_CONVOLUTION_HEIGHT                             = $8019;
  GL_MAX_CONVOLUTION_WIDTH                          = $801A;
  GL_MAX_CONVOLUTION_HEIGHT                         = $801B;
  GL_POST_CONVOLUTION_RED_SCALE                     = $801C;
  GL_POST_CONVOLUTION_GREEN_SCALE                   = $801D;
  GL_POST_CONVOLUTION_BLUE_SCALE                    = $801E;
  GL_POST_CONVOLUTION_ALPHA_SCALE                   = $801F;
  GL_POST_CONVOLUTION_RED_BIAS                      = $8020;
  GL_POST_CONVOLUTION_GREEN_BIAS                    = $8021;
  GL_POST_CONVOLUTION_BLUE_BIAS                     = $8022;
  GL_POST_CONVOLUTION_ALPHA_BIAS                    = $8023;

  // histogram GL 1.2 ARB imaging
  GL_HISTOGRAM                                      = $8024;
  GL_PROXY_HISTOGRAM                                = $8025;
  GL_HISTOGRAM_WIDTH                                = $8026;
  GL_HISTOGRAM_FORMAT                               = $8027;
  GL_HISTOGRAM_RED_SIZE                             = $8028;
  GL_HISTOGRAM_GREEN_SIZE                           = $8029;
  GL_HISTOGRAM_BLUE_SIZE                            = $802A;
  GL_HISTOGRAM_ALPHA_SIZE                           = $802B;
  GL_HISTOGRAM_LUMINANCE_SIZE                       = $802C;
  GL_HISTOGRAM_SINK                                 = $802D;
  GL_MINMAX                                         = $802E;
  GL_MINMAX_FORMAT                                  = $802F;
  GL_MINMAX_SINK                                    = $8030;

  // buffers
  GL_NONE                                           = 0;
  GL_FRONT_LEFT                                     = $0400;
  GL_FRONT_RIGHT                                    = $0401;
  GL_BACK_LEFT                                      = $0402;
  GL_BACK_RIGHT                                     = $0403;
  GL_FRONT                                          = $0404;
  GL_BACK                                           = $0405;
  GL_LEFT                                           = $0406;
  GL_RIGHT                                          = $0407;
  GL_FRONT_AND_BACK                                 = $0408;
  GL_AUX0                                           = $0409;
  GL_AUX1                                           = $040A;
  GL_AUX2                                           = $040B;
  GL_AUX3                                           = $040C;
  GL_AUX_BUFFERS                                    = $0C00;
  GL_DRAW_BUFFER                                    = $0C01;
  GL_READ_BUFFER                                    = $0C02;
  GL_DOUBLEBUFFER                                   = $0C32;
  GL_STEREO                                         = $0C33;

  // depth buffer
  GL_DEPTH_RANGE                                    = $0B70;
  GL_DEPTH_TEST                                     = $0B71;
  GL_DEPTH_WRITEMASK                                = $0B72;
  GL_DEPTH_CLEAR_VALUE                              = $0B73;
  GL_DEPTH_FUNC                                     = $0B74;
  GL_NEVER                                          = $0200;
  GL_LESS                                           = $0201;
  GL_EQUAL                                          = $0202;
  GL_LEQUAL                                         = $0203;
  GL_GREATER                                        = $0204;
  GL_NOTEQUAL                                       = $0205;
  GL_GEQUAL                                         = $0206;
  GL_ALWAYS                                         = $0207;

  // accumulation buffer
  GL_ACCUM                                          = $0100;
  GL_LOAD                                           = $0101;
  GL_RETURN                                         = $0102;
  GL_MULT                                           = $0103;
  GL_ADD                                            = $0104;
  GL_ACCUM_CLEAR_VALUE                              = $0B80;

  // feedback buffer
  GL_FEEDBACK_BUFFER_POINTER                        = $0DF0;
  GL_FEEDBACK_BUFFER_SIZE                           = $0DF1;
  GL_FEEDBACK_BUFFER_TYPE                           = $0DF2;

  // feedback types
  GL_2D                                             = $0600;
  GL_3D                                             = $0601;
  GL_3D_COLOR                                       = $0602;
  GL_3D_COLOR_TEXTURE                               = $0603;
  GL_4D_COLOR_TEXTURE                               = $0604;

  // feedback tokens
  GL_PASS_THROUGH_TOKEN                             = $0700;
  GL_POINT_TOKEN                                    = $0701;
  GL_LINE_TOKEN                                     = $0702;
  GL_POLYGON_TOKEN                                  = $0703;
  GL_BITMAP_TOKEN                                   = $0704;
  GL_DRAW_PIXEL_TOKEN                               = $0705;
  GL_COPY_PIXEL_TOKEN                               = $0706;
  GL_LINE_RESET_TOKEN                               = $0707;

  // fog
  GL_EXP                                            = $0800;
  GL_EXP2                                           = $0801;
  GL_FOG                                            = $0B60;
  GL_FOG_INDEX                                      = $0B61;
  GL_FOG_DENSITY                                    = $0B62;
  GL_FOG_START                                      = $0B63;
  GL_FOG_END                                        = $0B64;
  GL_FOG_MODE                                       = $0B65;
  GL_FOG_COLOR                                      = $0B66;

  // pixel mode, transfer
  GL_PIXEL_MAP_I_TO_I                               = $0C70;
  GL_PIXEL_MAP_S_TO_S                               = $0C71;
  GL_PIXEL_MAP_I_TO_R                               = $0C72;
  GL_PIXEL_MAP_I_TO_G                               = $0C73;
  GL_PIXEL_MAP_I_TO_B                               = $0C74;
  GL_PIXEL_MAP_I_TO_A                               = $0C75;
  GL_PIXEL_MAP_R_TO_R                               = $0C76;
  GL_PIXEL_MAP_G_TO_G                               = $0C77;
  GL_PIXEL_MAP_B_TO_B                               = $0C78;
  GL_PIXEL_MAP_A_TO_A                               = $0C79;

  // vertex arrays
  GL_VERTEX_ARRAY_POINTER                           = $808E;
  GL_NORMAL_ARRAY_POINTER                           = $808F;
  GL_COLOR_ARRAY_POINTER                            = $8090;
  GL_INDEX_ARRAY_POINTER                            = $8091;
  GL_TEXTURE_COORD_ARRAY_POINTER                    = $8092;
  GL_EDGE_FLAG_ARRAY_POINTER                        = $8093;

  // stenciling
  GL_STENCIL_TEST                                   = $0B90;
  GL_STENCIL_CLEAR_VALUE                            = $0B91;
  GL_STENCIL_FUNC                                   = $0B92;
  GL_STENCIL_VALUE_MASK                             = $0B93;
  GL_STENCIL_FAIL                                   = $0B94;
  GL_STENCIL_PASS_DEPTH_FAIL                        = $0B95;
  GL_STENCIL_PASS_DEPTH_PASS                        = $0B96;
  GL_STENCIL_REF                                    = $0B97;
  GL_STENCIL_WRITEMASK                              = $0B98;
  GL_KEEP                                           = $1E00;
  GL_REPLACE                                        = $1E01;
  GL_INCR                                           = $1E02;
  GL_DECR                                           = $1E03;

  // color material
  GL_COLOR_MATERIAL_FACE                            = $0B55;
  GL_COLOR_MATERIAL_PARAMETER                       = $0B56;
  GL_COLOR_MATERIAL                                 = $0B57;

  // points
  GL_POINT_SMOOTH                                   = $0B10;
  GL_POINT_SIZE                                     = $0B11;
  GL_POINT_SIZE_RANGE                               = $0B12;
  GL_POINT_SIZE_GRANULARITY                         = $0B13;

  // lines
  GL_LINE_SMOOTH                                    = $0B20;
  GL_LINE_WIDTH                                     = $0B21;
  GL_LINE_WIDTH_RANGE                               = $0B22;
  GL_LINE_WIDTH_GRANULARITY                         = $0B23;
  GL_LINE_STIPPLE                                   = $0B24;
  GL_LINE_STIPPLE_PATTERN                           = $0B25;
  GL_LINE_STIPPLE_REPEAT                            = $0B26;

  // polygons
  GL_POLYGON_MODE                                   = $0B40;
  GL_POLYGON_SMOOTH                                 = $0B41;
  GL_POLYGON_STIPPLE                                = $0B42;
  GL_EDGE_FLAG                                      = $0B43;
  GL_CULL_FACE                                      = $0B44;
  GL_CULL_FACE_MODE                                 = $0B45;
  GL_FRONT_FACE                                     = $0B46;
  GL_CW                                             = $0900;
  GL_CCW                                            = $0901;
  GL_POINT                                          = $1B00;
  GL_LINE                                           = $1B01;
  GL_FILL                                           = $1B02;

  // display lists
  GL_LIST_MODE                                      = $0B30;
  GL_LIST_BASE                                      = $0B32;
  GL_LIST_INDEX                                     = $0B33;
  GL_COMPILE                                        = $1300;
  GL_COMPILE_AND_EXECUTE                            = $1301;

  // lighting
  GL_LIGHTING                                       = $0B50;
  GL_LIGHT_MODEL_LOCAL_VIEWER                       = $0B51;
  GL_LIGHT_MODEL_TWO_SIDE                           = $0B52;
  GL_LIGHT_MODEL_AMBIENT                            = $0B53;
  GL_LIGHT_MODEL_COLOR_CONTROL                      = $81F8; // GL 1.2
  GL_SHADE_MODEL                                    = $0B54;
  GL_NORMALIZE                                      = $0BA1;
  GL_AMBIENT                                        = $1200;
  GL_DIFFUSE                                        = $1201;
  GL_SPECULAR                                       = $1202;
  GL_POSITION                                       = $1203;
  GL_SPOT_DIRECTION                                 = $1204;
  GL_SPOT_EXPONENT                                  = $1205;
  GL_SPOT_CUTOFF                                    = $1206;
  GL_CONSTANT_ATTENUATION                           = $1207;
  GL_LINEAR_ATTENUATION                             = $1208;
  GL_QUADRATIC_ATTENUATION                          = $1209;
  GL_EMISSION                                       = $1600;
  GL_SHININESS                                      = $1601;
  GL_AMBIENT_AND_DIFFUSE                            = $1602;
  GL_COLOR_INDEXES                                  = $1603;
  GL_FLAT                                           = $1D00;
  GL_SMOOTH                                         = $1D01;
  GL_LIGHT0                                         = $4000;
  GL_LIGHT1                                         = $4001;
  GL_LIGHT2                                         = $4002;
  GL_LIGHT3                                         = $4003;
  GL_LIGHT4                                         = $4004;
  GL_LIGHT5                                         = $4005;
  GL_LIGHT6                                         = $4006;
  GL_LIGHT7                                         = $4007;

  // matrix modes
  GL_MATRIX_MODE                                    = $0BA0;
  GL_MODELVIEW                                      = $1700;
  GL_PROJECTION                                     = $1701;
  GL_TEXTURE                                        = $1702;

  // gets
  GL_CURRENT_COLOR                                  = $0B00;
  GL_CURRENT_INDEX                                  = $0B01;
  GL_CURRENT_NORMAL                                 = $0B02;
  GL_CURRENT_TEXTURE_COORDS                         = $0B03;
  GL_CURRENT_RASTER_COLOR                           = $0B04;
  GL_CURRENT_RASTER_INDEX                           = $0B05;
  GL_CURRENT_RASTER_TEXTURE_COORDS                  = $0B06;
  GL_CURRENT_RASTER_POSITION                        = $0B07;
  GL_CURRENT_RASTER_POSITION_VALID                  = $0B08;
  GL_CURRENT_RASTER_DISTANCE                        = $0B09;
  GL_MAX_LIST_NESTING                               = $0B31;
  GL_VIEWPORT                                       = $0BA2;
  GL_MODELVIEW_STACK_DEPTH                          = $0BA3;
  GL_PROJECTION_STACK_DEPTH                         = $0BA4;
  GL_TEXTURE_STACK_DEPTH                            = $0BA5;
  GL_MODELVIEW_MATRIX                               = $0BA6;
  GL_PROJECTION_MATRIX                              = $0BA7;
  GL_TEXTURE_MATRIX                                 = $0BA8;
  GL_ATTRIB_STACK_DEPTH                             = $0BB0;
  GL_CLIENT_ATTRIB_STACK_DEPTH                      = $0BB1;

  GL_SINGLE_COLOR                                   = $81F9; // GL 1.2
  GL_SEPARATE_SPECULAR_COLOR                        = $81FA; // GL 1.2

  // alpha testing
  GL_ALPHA_TEST                                     = $0BC0;
  GL_ALPHA_TEST_FUNC                                = $0BC1;
  GL_ALPHA_TEST_REF                                 = $0BC2;

  GL_LOGIC_OP_MODE                                  = $0BF0;
  GL_INDEX_LOGIC_OP                                 = $0BF1;
  GL_LOGIC_OP                                       = $0BF1;
  GL_COLOR_LOGIC_OP                                 = $0BF2;
  GL_SCISSOR_BOX                                    = $0C10;
  GL_SCISSOR_TEST                                   = $0C11;
  GL_INDEX_CLEAR_VALUE                              = $0C20;
  GL_INDEX_WRITEMASK                                = $0C21;
  GL_COLOR_CLEAR_VALUE                              = $0C22;
  GL_COLOR_WRITEMASK                                = $0C23;
  GL_INDEX_MODE                                     = $0C30;
  GL_RGBA_MODE                                      = $0C31;
  GL_RENDER_MODE                                    = $0C40;
  GL_PERSPECTIVE_CORRECTION_HINT                    = $0C50;
  GL_POINT_SMOOTH_HINT                              = $0C51;
  GL_LINE_SMOOTH_HINT                               = $0C52;
  GL_POLYGON_SMOOTH_HINT                            = $0C53;
  GL_FOG_HINT                                       = $0C54;
  GL_TEXTURE_GEN_S                                  = $0C60;
  GL_TEXTURE_GEN_T                                  = $0C61;
  GL_TEXTURE_GEN_R                                  = $0C62;
  GL_TEXTURE_GEN_Q                                  = $0C63;
  GL_PIXEL_MAP_I_TO_I_SIZE                          = $0CB0;
  GL_PIXEL_MAP_S_TO_S_SIZE                          = $0CB1;
  GL_PIXEL_MAP_I_TO_R_SIZE                          = $0CB2;
  GL_PIXEL_MAP_I_TO_G_SIZE                          = $0CB3;
  GL_PIXEL_MAP_I_TO_B_SIZE                          = $0CB4;
  GL_PIXEL_MAP_I_TO_A_SIZE                          = $0CB5;
  GL_PIXEL_MAP_R_TO_R_SIZE                          = $0CB6;
  GL_PIXEL_MAP_G_TO_G_SIZE                          = $0CB7;
  GL_PIXEL_MAP_B_TO_B_SIZE                          = $0CB8;
  GL_PIXEL_MAP_A_TO_A_SIZE                          = $0CB9;
  GL_UNPACK_SWAP_BYTES                              = $0CF0;
  GL_UNPACK_LSB_FIRST                               = $0CF1;
  GL_UNPACK_ROW_LENGTH                              = $0CF2;
  GL_UNPACK_SKIP_ROWS                               = $0CF3;
  GL_UNPACK_SKIP_PIXELS                             = $0CF4;
  GL_UNPACK_ALIGNMENT                               = $0CF5;
  GL_PACK_SWAP_BYTES                                = $0D00;
  GL_PACK_LSB_FIRST                                 = $0D01;
  GL_PACK_ROW_LENGTH                                = $0D02;
  GL_PACK_SKIP_ROWS                                 = $0D03;
  GL_PACK_SKIP_PIXELS                               = $0D04;
  GL_PACK_ALIGNMENT                                 = $0D05;
  GL_PACK_SKIP_IMAGES                               = $806B; // GL 1.2
  GL_PACK_IMAGE_HEIGHT                              = $806C; // GL 1.2
  GL_UNPACK_SKIP_IMAGES                             = $806D; // GL 1.2
  GL_UNPACK_IMAGE_HEIGHT                            = $806E; // GL 1.2
  GL_MAP_COLOR                                      = $0D10;
  GL_MAP_STENCIL                                    = $0D11;
  GL_INDEX_SHIFT                                    = $0D12;
  GL_INDEX_OFFSET                                   = $0D13;
  GL_RED_SCALE                                      = $0D14;
  GL_RED_BIAS                                       = $0D15;
  GL_ZOOM_X                                         = $0D16;
  GL_ZOOM_Y                                         = $0D17;
  GL_GREEN_SCALE                                    = $0D18;
  GL_GREEN_BIAS                                     = $0D19;
  GL_BLUE_SCALE                                     = $0D1A;
  GL_BLUE_BIAS                                      = $0D1B;
  GL_ALPHA_SCALE                                    = $0D1C;
  GL_ALPHA_BIAS                                     = $0D1D;
  GL_DEPTH_SCALE                                    = $0D1E;
  GL_DEPTH_BIAS                                     = $0D1F;
  GL_MAX_EVAL_ORDER                                 = $0D30;
  GL_MAX_LIGHTS                                     = $0D31;
  GL_MAX_CLIP_PLANES                                = $0D32;
  GL_MAX_TEXTURE_SIZE                               = $0D33;
  GL_MAX_3D_TEXTURE_SIZE                            = $8073; // GL 1.2
  GL_MAX_PIXEL_MAP_TABLE                            = $0D34;
  GL_MAX_ATTRIB_STACK_DEPTH                         = $0D35;
  GL_MAX_MODELVIEW_STACK_DEPTH                      = $0D36;
  GL_MAX_NAME_STACK_DEPTH                           = $0D37;
  GL_MAX_PROJECTION_STACK_DEPTH                     = $0D38;
  GL_MAX_TEXTURE_STACK_DEPTH                        = $0D39;
  GL_MAX_VIEWPORT_DIMS                              = $0D3A;
  GL_MAX_CLIENT_ATTRIB_STACK_DEPTH                  = $0D3B;
  GL_MAX_ELEMENTS_VERTICES                          = $80E8; // GL 1.2
  GL_MAX_ELEMENTS_INDICES                           = $80E9; // GL 1.2
  GL_RESCALE_NORMAL                                 = $803A; // GL 1.2
  GL_SUBPIXEL_BITS                                  = $0D50;
  GL_INDEX_BITS                                     = $0D51;
  GL_RED_BITS                                       = $0D52;
  GL_GREEN_BITS                                     = $0D53;
  GL_BLUE_BITS                                      = $0D54;
  GL_ALPHA_BITS                                     = $0D55;
  GL_DEPTH_BITS                                     = $0D56;
  GL_STENCIL_BITS                                   = $0D57;
  GL_ACCUM_RED_BITS                                 = $0D58;
  GL_ACCUM_GREEN_BITS                               = $0D59;
  GL_ACCUM_BLUE_BITS                                = $0D5A;
  GL_ACCUM_ALPHA_BITS                               = $0D5B;
  GL_NAME_STACK_DEPTH                               = $0D70;
  GL_AUTO_NORMAL                                    = $0D80;
  GL_MAP1_COLOR_4                                   = $0D90;
  GL_MAP1_INDEX                                     = $0D91;
  GL_MAP1_NORMAL                                    = $0D92;
  GL_MAP1_TEXTURE_COORD_1                           = $0D93;
  GL_MAP1_TEXTURE_COORD_2                           = $0D94;
  GL_MAP1_TEXTURE_COORD_3                           = $0D95;
  GL_MAP1_TEXTURE_COORD_4                           = $0D96;
  GL_MAP1_VERTEX_3                                  = $0D97;
  GL_MAP1_VERTEX_4                                  = $0D98;
  GL_MAP2_COLOR_4                                   = $0DB0;
  GL_MAP2_INDEX                                     = $0DB1;
  GL_MAP2_NORMAL                                    = $0DB2;
  GL_MAP2_TEXTURE_COORD_1                           = $0DB3;
  GL_MAP2_TEXTURE_COORD_2                           = $0DB4;
  GL_MAP2_TEXTURE_COORD_3                           = $0DB5;
  GL_MAP2_TEXTURE_COORD_4                           = $0DB6;
  GL_MAP2_VERTEX_3                                  = $0DB7;
  GL_MAP2_VERTEX_4                                  = $0DB8;
  GL_MAP1_GRID_DOMAIN                               = $0DD0;
  GL_MAP1_GRID_SEGMENTS                             = $0DD1;
  GL_MAP2_GRID_DOMAIN                               = $0DD2;
  GL_MAP2_GRID_SEGMENTS                             = $0DD3;
  GL_TEXTURE_1D                                     = $0DE0;
  GL_TEXTURE_2D                                     = $0DE1;
  GL_TEXTURE_3D                                     = $806F; // GL 1.2
  GL_SELECTION_BUFFER_POINTER                       = $0DF3;
  GL_SELECTION_BUFFER_SIZE                          = $0DF4;
  GL_POLYGON_OFFSET_UNITS                           = $2A00;
  GL_POLYGON_OFFSET_POINT                           = $2A01;
  GL_POLYGON_OFFSET_LINE                            = $2A02;
  GL_POLYGON_OFFSET_FILL                            = $8037;
  GL_POLYGON_OFFSET_FACTOR                          = $8038;
  GL_TEXTURE_BINDING_1D                             = $8068;
  GL_TEXTURE_BINDING_2D                             = $8069;
  GL_VERTEX_ARRAY                                   = $8074;
  GL_NORMAL_ARRAY                                   = $8075;
  GL_COLOR_ARRAY                                    = $8076;
  GL_INDEX_ARRAY                                    = $8077;
  GL_TEXTURE_COORD_ARRAY                            = $8078;
  GL_EDGE_FLAG_ARRAY                                = $8079;
  GL_VERTEX_ARRAY_SIZE                              = $807A;
  GL_VERTEX_ARRAY_TYPE                              = $807B;
  GL_VERTEX_ARRAY_STRIDE                            = $807C;
  GL_NORMAL_ARRAY_TYPE                              = $807E;
  GL_NORMAL_ARRAY_STRIDE                            = $807F;
  GL_COLOR_ARRAY_SIZE                               = $8081;
  GL_COLOR_ARRAY_TYPE                               = $8082;
  GL_COLOR_ARRAY_STRIDE                             = $8083;
  GL_INDEX_ARRAY_TYPE                               = $8085;
  GL_INDEX_ARRAY_STRIDE                             = $8086;
  GL_TEXTURE_COORD_ARRAY_SIZE                       = $8088;
  GL_TEXTURE_COORD_ARRAY_TYPE                       = $8089;
  GL_TEXTURE_COORD_ARRAY_STRIDE                     = $808A;
  GL_EDGE_FLAG_ARRAY_STRIDE                         = $808C;
  GL_COLOR_MATRIX                                   = $80B1; // GL 1.2 ARB imaging
  GL_COLOR_MATRIX_STACK_DEPTH                       = $80B2; // GL 1.2 ARB imaging
  GL_MAX_COLOR_MATRIX_STACK_DEPTH                   = $80B3; // GL 1.2 ARB imaging
  GL_POST_COLOR_MATRIX_RED_SCALE                    = $80B4; // GL 1.2 ARB imaging
  GL_POST_COLOR_MATRIX_GREEN_SCALE                  = $80B5; // GL 1.2 ARB imaging
  GL_POST_COLOR_MATRIX_BLUE_SCALE                   = $80B6; // GL 1.2 ARB imaging
  GL_POST_COLOR_MATRIX_ALPHA_SCALE                  = $80B7; // GL 1.2 ARB imaging
  GL_POST_COLOR_MATRIX_RED_BIAS                     = $80B8; // GL 1.2 ARB imaging
  GL_POST_COLOR_MATRIX_GREEN_BIAS                   = $80B9; // GL 1.2 ARB imaging
  GL_POST_COLOR_MATRIX_BLUE_BIAS                    = $80BA; // GL 1.2 ARB imaging
  GL_POST_COLOR_MATRIX_ALPHA_BIAS                   = $80BB; // GL 1.2 ARB imaging

  // evaluators
  GL_COEFF                                          = $0A00;
  GL_ORDER                                          = $0A01;
  GL_DOMAIN                                         = $0A02;
  
  // texture mapping
  GL_TEXTURE_WIDTH                                  = $1000;
  GL_TEXTURE_HEIGHT                                 = $1001;
  GL_TEXTURE_INTERNAL_FORMAT                        = $1003;
  GL_TEXTURE_COMPONENTS                             = $1003;
  GL_TEXTURE_BORDER_COLOR                           = $1004;
  GL_TEXTURE_BORDER                                 = $1005;
  GL_TEXTURE_RED_SIZE                               = $805C;
  GL_TEXTURE_GREEN_SIZE                             = $805D;
  GL_TEXTURE_BLUE_SIZE                              = $805E;
  GL_TEXTURE_ALPHA_SIZE                             = $805F;
  GL_TEXTURE_LUMINANCE_SIZE                         = $8060;
  GL_TEXTURE_INTENSITY_SIZE                         = $8061;
  GL_TEXTURE_PRIORITY                               = $8066;
  GL_TEXTURE_RESIDENT                               = $8067;
  GL_BGR                                            = $80E0; // v 1.2
  GL_BGRA                                           = $80E1; // v 1.2
  GL_S                                              = $2000;
  GL_T                                              = $2001;
  GL_R                                              = $2002;
  GL_Q                                              = $2003;
  GL_MODULATE                                       = $2100;
  GL_DECAL                                          = $2101;
  GL_TEXTURE_ENV_MODE                               = $2200;
  GL_TEXTURE_ENV_COLOR                              = $2201;
  GL_TEXTURE_ENV                                    = $2300;
  GL_EYE_LINEAR                                     = $2400;
  GL_OBJECT_LINEAR                                  = $2401;
  GL_SPHERE_MAP                                     = $2402;
  GL_TEXTURE_GEN_MODE                               = $2500;
  GL_OBJECT_PLANE                                   = $2501;
  GL_EYE_PLANE                                      = $2502;
  GL_NEAREST                                        = $2600;
  GL_LINEAR                                         = $2601;
  GL_NEAREST_MIPMAP_NEAREST                         = $2700;
  GL_LINEAR_MIPMAP_NEAREST                          = $2701;
  GL_NEAREST_MIPMAP_LINEAR                          = $2702;
  GL_LINEAR_MIPMAP_LINEAR                           = $2703;
  GL_TEXTURE_MAG_FILTER                             = $2800;
  GL_TEXTURE_MIN_FILTER                             = $2801;
  GL_TEXTURE_WRAP_R                                 = $8072; // GL 1.2
  GL_TEXTURE_WRAP_S                                 = $2802;
  GL_TEXTURE_WRAP_T                                 = $2803;
  GL_CLAMP_TO_EDGE                                  = $812F; // GL 1.2
  GL_TEXTURE_MIN_LOD                                = $813A; // GL 1.2
  GL_TEXTURE_MAX_LOD                                = $813B; // GL 1.2
  GL_TEXTURE_BASE_LEVEL                             = $813C; // GL 1.2
  GL_TEXTURE_MAX_LEVEL                              = $813D; // GL 1.2
  GL_TEXTURE_DEPTH                                  = $8071; // GL 1.2
  GL_PROXY_TEXTURE_1D                               = $8063;
  GL_PROXY_TEXTURE_2D                               = $8064;
  GL_PROXY_TEXTURE_3D                               = $8070; // GL 1.2
  GL_CLAMP                                          = $2900;
  GL_REPEAT                                         = $2901;

  // hints
  GL_DONT_CARE                                      = $1100;
  GL_FASTEST                                        = $1101;
  GL_NICEST                                         = $1102;

  // data types
  GL_BYTE                                           = $1400;
  GL_UNSIGNED_BYTE                                  = $1401;
  GL_SHORT                                          = $1402;
  GL_UNSIGNED_SHORT                                 = $1403;
  GL_INT                                            = $1404;
  GL_UNSIGNED_INT                                   = $1405;
  GL_FLOAT                                          = $1406;
  GL_2_BYTES                                        = $1407;
  GL_3_BYTES                                        = $1408;
  GL_4_BYTES                                        = $1409;
  GL_DOUBLE                                         = $140A;
  GL_DOUBLE_EXT                                     = $140A;

  // logic operations
  GL_CLEAR                                          = $1500;
  GL_AND                                            = $1501;
  GL_AND_REVERSE                                    = $1502;
  GL_COPY                                           = $1503;
  GL_AND_INVERTED                                   = $1504;
  GL_NOOP                                           = $1505;
  GL_XOR                                            = $1506;
  GL_OR                                             = $1507;
  GL_NOR                                            = $1508;
  GL_EQUIV                                          = $1509;
  GL_INVERT                                         = $150A;
  GL_OR_REVERSE                                     = $150B;
  GL_COPY_INVERTED                                  = $150C;
  GL_OR_INVERTED                                    = $150D;
  GL_NAND                                           = $150E;
  GL_SET                                            = $150F;

  // PixelCopyType
  GL_COLOR                                          = $1800;
  GL_DEPTH                                          = $1801;
  GL_STENCIL                                        = $1802;

  // pixel formats
  GL_COLOR_INDEX                                    = $1900;
  GL_STENCIL_INDEX                                  = $1901;
  GL_DEPTH_COMPONENT                                = $1902;
  GL_RED                                            = $1903;
  GL_GREEN                                          = $1904;
  GL_BLUE                                           = $1905;
  GL_ALPHA                                          = $1906;
  GL_RGB                                            = $1907;
  GL_RGBA                                           = $1908;
  GL_LUMINANCE                                      = $1909;
  GL_LUMINANCE_ALPHA                                = $190A;

  // pixel type
  GL_BITMAP                                         = $1A00;

  // rendering modes
  GL_RENDER                                         = $1C00;
  GL_FEEDBACK                                       = $1C01;
  GL_SELECT                                         = $1C02;

  // implementation strings
  GL_VENDOR                                         = $1F00;
  GL_RENDERER                                       = $1F01;
  GL_VERSION                                        = $1F02;
  GL_EXTENSIONS                                     = $1F03;

  // pixel formats
  GL_R3_G3_B2                                       = $2A10;
  GL_ALPHA4                                         = $803B;
  GL_ALPHA8                                         = $803C;
  GL_ALPHA12                                        = $803D;
  GL_ALPHA16                                        = $803E;
  GL_LUMINANCE4                                     = $803F;
  GL_LUMINANCE8                                     = $8040;
  GL_LUMINANCE12                                    = $8041;
  GL_LUMINANCE16                                    = $8042;
  GL_LUMINANCE4_ALPHA4                              = $8043;
  GL_LUMINANCE6_ALPHA2                              = $8044;
  GL_LUMINANCE8_ALPHA8                              = $8045;
  GL_LUMINANCE12_ALPHA4                             = $8046;
  GL_LUMINANCE12_ALPHA12                            = $8047;
  GL_LUMINANCE16_ALPHA16                            = $8048;
  GL_INTENSITY                                      = $8049;
  GL_INTENSITY4                                     = $804A;
  GL_INTENSITY8                                     = $804B;
  GL_INTENSITY12                                    = $804C;
  GL_INTENSITY16                                    = $804D;
  GL_RGB4                                           = $804F;
  GL_RGB5                                           = $8050;
  GL_RGB8                                           = $8051;
  GL_RGB10                                          = $8052;
  GL_RGB12                                          = $8053;
  GL_RGB16                                          = $8054;
  GL_RGBA2                                          = $8055;
  GL_RGBA4                                          = $8056;
  GL_RGB5_A1                                        = $8057;
  GL_RGBA8                                          = $8058;
  GL_RGB10_A2                                       = $8059;
  GL_RGBA12                                         = $805A;
  GL_RGBA16                                         = $805B;
  UNSIGNED_BYTE_3_3_2                               = $8032; // GL 1.2
  UNSIGNED_BYTE_2_3_3_REV                           = $8362; // GL 1.2
  UNSIGNED_SHORT_5_6_5                              = $8363; // GL 1.2
  UNSIGNED_SHORT_5_6_5_REV                          = $8364; // GL 1.2
  UNSIGNED_SHORT_4_4_4_4                            = $8033; // GL 1.2
  UNSIGNED_SHORT_4_4_4_4_REV                        = $8365; // GL 1.2
  UNSIGNED_SHORT_5_5_5_1                            = $8034; // GL 1.2
  UNSIGNED_SHORT_1_5_5_5_REV                        = $8366; // GL 1.2
  UNSIGNED_INT_8_8_8_8                              = $8035; // GL 1.2
  UNSIGNED_INT_8_8_8_8_REV                          = $8367; // GL 1.2
  UNSIGNED_INT_10_10_10_2                           = $8036; // GL 1.2
  UNSIGNED_INT_2_10_10_10_REV                       = $8368; // GL 1.2

  // interleaved arrays formats
  GL_V2F                                            = $2A20;
  GL_V3F                                            = $2A21;
  GL_C4UB_V2F                                       = $2A22;
  GL_C4UB_V3F                                       = $2A23;
  GL_C3F_V3F                                        = $2A24;
  GL_N3F_V3F                                        = $2A25;
  GL_C4F_N3F_V3F                                    = $2A26;
  GL_T2F_V3F                                        = $2A27;
  GL_T4F_V4F                                        = $2A28;
  GL_T2F_C4UB_V3F                                   = $2A29;
  GL_T2F_C3F_V3F                                    = $2A2A;
  GL_T2F_N3F_V3F                                    = $2A2B;
  GL_T2F_C4F_N3F_V3F                                = $2A2C;
  GL_T4F_C4F_N3F_V4F                                = $2A2D;

  // clip planes
  GL_CLIP_PLANE0                                    = $3000;
  GL_CLIP_PLANE1                                    = $3001;
  GL_CLIP_PLANE2                                    = $3002;
  GL_CLIP_PLANE3                                    = $3003;
  GL_CLIP_PLANE4                                    = $3004;
  GL_CLIP_PLANE5                                    = $3005;

  // miscellaneous
  GL_DITHER                                         = $0BD0;
  
  // ----- extensions enumerants -----
  // EXT_abgr
  GL_ABGR_EXT                                       = $8000;

  // EXT_packed_pixels
  GL_UNSIGNED_BYTE_3_3_2_EXT                        = $8032;
  GL_UNSIGNED_SHORT_4_4_4_4_EXT                     = $8033;
  GL_UNSIGNED_SHORT_5_5_5_1_EXT                     = $8034;
  GL_UNSIGNED_INT_8_8_8_8_EXT                       = $8035;
  GL_UNSIGNED_INT_10_10_10_2_EXT                    = $8036;

  // EXT_vertex_array
  GL_VERTEX_ARRAY_EXT                               = $8074;
  GL_NORMAL_ARRAY_EXT                               = $8075;
  GL_COLOR_ARRAY_EXT                                = $8076;
  GL_INDEX_ARRAY_EXT                                = $8077;
  GL_TEXTURE_COORD_ARRAY_EXT                        = $8078;
  GL_EDGE_FLAG_ARRAY_EXT                            = $8079;
  GL_VERTEX_ARRAY_SIZE_EXT                          = $807A;
  GL_VERTEX_ARRAY_TYPE_EXT                          = $807B;
  GL_VERTEX_ARRAY_STRIDE_EXT                        = $807C;
  GL_VERTEX_ARRAY_COUNT_EXT                         = $807D;
  GL_NORMAL_ARRAY_TYPE_EXT                          = $807E;
  GL_NORMAL_ARRAY_STRIDE_EXT                        = $807F;
  GL_NORMAL_ARRAY_COUNT_EXT                         = $8080;
  GL_COLOR_ARRAY_SIZE_EXT                           = $8081;
  GL_COLOR_ARRAY_TYPE_EXT                           = $8082;
  GL_COLOR_ARRAY_STRIDE_EXT                         = $8083;
  GL_COLOR_ARRAY_COUNT_EXT                          = $8084;
  GL_INDEX_ARRAY_TYPE_EXT                           = $8085;
  GL_INDEX_ARRAY_STRIDE_EXT                         = $8086;
  GL_INDEX_ARRAY_COUNT_EXT                          = $8087;
  GL_TEXTURE_COORD_ARRAY_SIZE_EXT                   = $8088;
  GL_TEXTURE_COORD_ARRAY_TYPE_EXT                   = $8089;
  GL_TEXTURE_COORD_ARRAY_STRIDE_EXT                 = $808A;
  GL_TEXTURE_COORD_ARRAY_COUNT_EXT                  = $808B;
  GL_EDGE_FLAG_ARRAY_STRIDE_EXT                     = $808C;
  GL_EDGE_FLAG_ARRAY_COUNT_EXT                      = $808D;
  GL_VERTEX_ARRAY_POINTER_EXT                       = $808E;
  GL_NORMAL_ARRAY_POINTER_EXT                       = $808F;
  GL_COLOR_ARRAY_POINTER_EXT                        = $8090;
  GL_INDEX_ARRAY_POINTER_EXT                        = $8091;
  GL_TEXTURE_COORD_ARRAY_POINTER_EXT                = $8092;
  GL_EDGE_FLAG_ARRAY_POINTER_EXT                    = $8093;

  // EXT_color_table
  GL_TABLE_TOO_LARGE_EXT                            = $8031;
  GL_COLOR_TABLE_EXT                                = $80D0;
  GL_POST_CONVOLUTION_COLOR_TABLE_EXT               = $80D1;
  GL_POST_COLOR_MATRIX_COLOR_TABLE_EXT              = $80D2;
  GL_PROXY_COLOR_TABLE_EXT                          = $80D3;
  GL_PROXY_POST_CONVOLUTION_COLOR_TABLE_EXT         = $80D4;
  GL_PROXY_POST_COLOR_MATRIX_COLOR_TABLE_EXT        = $80D5;
  GL_COLOR_TABLE_SCALE_EXT                          = $80D6;
  GL_COLOR_TABLE_BIAS_EXT                           = $80D7;
  GL_COLOR_TABLE_FORMAT_EXT                         = $80D8;
  GL_COLOR_TABLE_WIDTH_EXT                          = $80D9;
  GL_COLOR_TABLE_RED_SIZE_EXT                       = $80DA;
  GL_COLOR_TABLE_GREEN_SIZE_EXT                     = $80DB;
  GL_COLOR_TABLE_BLUE_SIZE_EXT                      = $80DC;
  GL_COLOR_TABLE_ALPHA_SIZE_EXT                     = $80DD;
  GL_COLOR_TABLE_LUMINANCE_SIZE_EXT                 = $80DE;
  GL_COLOR_TABLE_INTENSITY_SIZE_EXT                 = $80DF;

  // EXT_bgra
  GL_BGR_EXT                                        = $80E0;
  GL_BGRA_EXT                                       = $80E1;

  // EXT_paletted_texture
  GL_COLOR_INDEX1_EXT                               = $80E2;
  GL_COLOR_INDEX2_EXT                               = $80E3;
  GL_COLOR_INDEX4_EXT                               = $80E4;
  GL_COLOR_INDEX8_EXT                               = $80E5;
  GL_COLOR_INDEX12_EXT                              = $80E6;
  GL_COLOR_INDEX16_EXT                              = $80E7;

  // EXT_blend_color
  GL_CONSTANT_COLOR_EXT                             = $8001;
  GL_ONE_MINUS_CONSTANT_COLOR_EXT                   = $8002;
  GL_CONSTANT_ALPHA_EXT                             = $8003;
  GL_ONE_MINUS_CONSTANT_ALPHA_EXT                   = $8004;
  GL_BLEND_COLOR_EXT                                = $8005;

  // EXT_blend_minmax
  GL_FUNC_ADD_EXT                                   = $8006;
  GL_MIN_EXT                                        = $8007;
  GL_MAX_EXT                                        = $8008;
  GL_BLEND_EQUATION_EXT                             = $8009;

  // EXT_blend_subtract
  GL_FUNC_SUBTRACT_EXT                              = $800A;
  GL_FUNC_REVERSE_SUBTRACT_EXT                      = $800B;

  // EXT_convolution
  GL_CONVOLUTION_1D_EXT                             = $8010;
  GL_CONVOLUTION_2D_EXT                             = $8011;
  GL_SEPARABLE_2D_EXT                               = $8012;
  GL_CONVOLUTION_BORDER_MODE_EXT                    = $8013;
  GL_CONVOLUTION_FILTER_SCALE_EXT                   = $8014;
  GL_CONVOLUTION_FILTER_BIAS_EXT                    = $8015;
  GL_REDUCE_EXT                                     = $8016;
  GL_CONVOLUTION_FORMAT_EXT                         = $8017;
  GL_CONVOLUTION_WIDTH_EXT                          = $8018;
  GL_CONVOLUTION_HEIGHT_EXT                         = $8019;
  GL_MAX_CONVOLUTION_WIDTH_EXT                      = $801A;
  GL_MAX_CONVOLUTION_HEIGHT_EXT                     = $801B;
  GL_POST_CONVOLUTION_RED_SCALE_EXT                 = $801C;
  GL_POST_CONVOLUTION_GREEN_SCALE_EXT               = $801D;
  GL_POST_CONVOLUTION_BLUE_SCALE_EXT                = $801E;
  GL_POST_CONVOLUTION_ALPHA_SCALE_EXT               = $801F;
  GL_POST_CONVOLUTION_RED_BIAS_EXT                  = $8020;
  GL_POST_CONVOLUTION_GREEN_BIAS_EXT                = $8021;
  GL_POST_CONVOLUTION_BLUE_BIAS_EXT                 = $8022;
  GL_POST_CONVOLUTION_ALPHA_BIAS_EXT                = $8023;

  // EXT_histogram
  GL_HISTOGRAM_EXT                                  = $8024;
  GL_PROXY_HISTOGRAM_EXT                            = $8025;
  GL_HISTOGRAM_WIDTH_EXT                            = $8026;
  GL_HISTOGRAM_FORMAT_EXT                           = $8027;
  GL_HISTOGRAM_RED_SIZE_EXT                         = $8028;
  GL_HISTOGRAM_GREEN_SIZE_EXT                       = $8029;
  GL_HISTOGRAM_BLUE_SIZE_EXT                        = $802A;
  GL_HISTOGRAM_ALPHA_SIZE_EXT                       = $802B;
  GL_HISTOGRAM_LUMINANCE_SIZE_EXT                   = $802C;
  GL_HISTOGRAM_SINK_EXT                             = $802D;
  GL_MINMAX_EXT                                     = $802E;
  GL_MINMAX_FORMAT_EXT                              = $802F;
  GL_MINMAX_SINK_EXT                                = $8030;

  // EXT_polygon_offset
  GL_POLYGON_OFFSET_EXT                             = $8037;
  GL_POLYGON_OFFSET_FACTOR_EXT                      = $8038;
  GL_POLYGON_OFFSET_BIAS_EXT                        = $8039;

  // EXT_texture
  GL_ALPHA4_EXT                                     = $803B;
  GL_ALPHA8_EXT                                     = $803C;
  GL_ALPHA12_EXT                                    = $803D;
  GL_ALPHA16_EXT                                    = $803E;
  GL_LUMINANCE4_EXT                                 = $803F;
  GL_LUMINANCE8_EXT                                 = $8040;
  GL_LUMINANCE12_EXT                                = $8041;
  GL_LUMINANCE16_EXT                                = $8042;
  GL_LUMINANCE4_ALPHA4_EXT                          = $8043;
  GL_LUMINANCE6_ALPHA2_EXT                          = $8044;
  GL_LUMINANCE8_ALPHA8_EXT                          = $8045;
  GL_LUMINANCE12_ALPHA4_EXT                         = $8046;
  GL_LUMINANCE12_ALPHA12_EXT                        = $8047;
  GL_LUMINANCE16_ALPHA16_EXT                        = $8048;
  GL_INTENSITY_EXT                                  = $8049;
  GL_INTENSITY4_EXT                                 = $804A;
  GL_INTENSITY8_EXT                                 = $804B;
  GL_INTENSITY12_EXT                                = $804C;
  GL_INTENSITY16_EXT                                = $804D;
  GL_RGB2_EXT                                       = $804E;
  GL_RGB4_EXT                                       = $804F;
  GL_RGB5_EXT                                       = $8050;
  GL_RGB8_EXT                                       = $8051;
  GL_RGB10_EXT                                      = $8052;
  GL_RGB12_EXT                                      = $8053;
  GL_RGB16_EXT                                      = $8054;
  GL_RGBA2_EXT                                      = $8055;
  GL_RGBA4_EXT                                      = $8056;
  GL_RGB5_A1_EXT                                    = $8057;
  GL_RGBA8_EXT                                      = $8058;
  GL_RGB10_A2_EXT                                   = $8059;
  GL_RGBA12_EXT                                     = $805A;
  GL_RGBA16_EXT                                     = $805B;
  GL_TEXTURE_RED_SIZE_EXT                           = $805C;
  GL_TEXTURE_GREEN_SIZE_EXT                         = $805D;
  GL_TEXTURE_BLUE_SIZE_EXT                          = $805E;
  GL_TEXTURE_ALPHA_SIZE_EXT                         = $805F;
  GL_TEXTURE_LUMINANCE_SIZE_EXT                     = $8060;
  GL_TEXTURE_INTENSITY_SIZE_EXT                     = $8061;
  GL_REPLACE_EXT                                    = $8062;
  GL_PROXY_TEXTURE_1D_EXT                           = $8063;
  GL_PROXY_TEXTURE_2D_EXT                           = $8064;
  GL_TEXTURE_TOO_LARGE_EXT                          = $8065;

  // EXT_texture_object
  GL_TEXTURE_PRIORITY_EXT                           = $8066;
  GL_TEXTURE_RESIDENT_EXT                           = $8067;
  GL_TEXTURE_1D_BINDING_EXT                         = $8068;
  GL_TEXTURE_2D_BINDING_EXT                         = $8069;
  GL_TEXTURE_3D_BINDING_EXT                         = $806A;

  // EXT_texture3D
  GL_PACK_SKIP_IMAGES_EXT                           = $806B;
  GL_PACK_IMAGE_HEIGHT_EXT                          = $806C;
  GL_UNPACK_SKIP_IMAGES_EXT                         = $806D;
  GL_UNPACK_IMAGE_HEIGHT_EXT                        = $806E;
  GL_TEXTURE_3D_EXT                                 = $806F;
  GL_PROXY_TEXTURE_3D_EXT                           = $8070;
  GL_TEXTURE_DEPTH_EXT                              = $8071;
  GL_TEXTURE_WRAP_R_EXT                             = $8072;
  GL_MAX_3D_TEXTURE_SIZE_EXT                        = $8073;

  // SGI_color_matrix
  GL_COLOR_MATRIX_SGI                               = $80B1;
  GL_COLOR_MATRIX_STACK_DEPTH_SGI                   = $80B2;
  GL_MAX_COLOR_MATRIX_STACK_DEPTH_SGI               = $80B3;
  GL_POST_COLOR_MATRIX_RED_SCALE_SGI                = $80B4;
  GL_POST_COLOR_MATRIX_GREEN_SCALE_SGI              = $80B5;
  GL_POST_COLOR_MATRIX_BLUE_SCALE_SGI               = $80B6;
  GL_POST_COLOR_MATRIX_ALPHA_SCALE_SGI              = $80B7;
  GL_POST_COLOR_MATRIX_RED_BIAS_SGI                 = $80B8;
  GL_POST_COLOR_MATRIX_GREEN_BIAS_SGI               = $80B9;
  GL_POST_COLOR_MATRIX_BLUE_BIAS_SGI                = $80BA;
  GL_POST_COLOR_MATRIX_ALPHA_BIAS_SGI               = $80BB;

  // SGI_texture_color_table
  GL_TEXTURE_COLOR_TABLE_SGI                        = $80BC;
  GL_PROXY_TEXTURE_COLOR_TABLE_SGI                  = $80BD;
  GL_TEXTURE_COLOR_TABLE_BIAS_SGI                   = $80BE;
  GL_TEXTURE_COLOR_TABLE_SCALE_SGI                  = $80BF;

  // SGI_color_table
  GL_COLOR_TABLE_SGI                                = $80D0;
  GL_POST_CONVOLUTION_COLOR_TABLE_SGI               = $80D1;
  GL_POST_COLOR_MATRIX_COLOR_TABLE_SGI              = $80D2;
  GL_PROXY_COLOR_TABLE_SGI                          = $80D3;
  GL_PROXY_POST_CONVOLUTION_COLOR_TABLE_SGI         = $80D4;
  GL_PROXY_POST_COLOR_MATRIX_COLOR_TABLE_SGI        = $80D5;
  GL_COLOR_TABLE_SCALE_SGI                          = $80D6;
  GL_COLOR_TABLE_BIAS_SGI                           = $80D7;
  GL_COLOR_TABLE_FORMAT_SGI                         = $80D8;
  GL_COLOR_TABLE_WIDTH_SGI                          = $80D9;
  GL_COLOR_TABLE_RED_SIZE_SGI                       = $80DA;
  GL_COLOR_TABLE_GREEN_SIZE_SGI                     = $80DB;
  GL_COLOR_TABLE_BLUE_SIZE_SGI                      = $80DC;
  GL_COLOR_TABLE_ALPHA_SIZE_SGI                     = $80DD;
  GL_COLOR_TABLE_LUMINANCE_SIZE_SGI                 = $80DE;
  GL_COLOR_TABLE_INTENSITY_SIZE_SGI                 = $80DF;

  // EXT_cmyka
  GL_CMYK_EXT                                       = $800C;
  GL_CMYKA_EXT                                      = $800D;
  GL_PACK_CMYK_HINT_EXT                             = $800E;
  GL_UNPACK_CMYK_HINT_EXT                           = $800F;

  // EXT_rescale_normal
  GL_RESCALE_NORMAL_EXT                             = $803A;

  // EXT_clip_volume_hint
  GL_CLIP_VOLUME_CLIPPING_HINT_EXT	                = $80F0;

  // EXT_cull_vertex
  GL_CULL_VERTEX_EXT                                = $81AA;
  GL_CULL_VERTEX_EYE_POSITION_EXT                   = $81AB;
  GL_CULL_VERTEX_OBJECT_POSITION_EXT                = $81AC;

  // EXT_index_array_formats
  GL_IUI_V2F_EXT                                    = $81AD;
  GL_IUI_V3F_EXT                                    = $81AE;
  GL_IUI_N3F_V2F_EXT                                = $81AF;
  GL_IUI_N3F_V3F_EXT                                = $81B0;
  GL_T2F_IUI_V2F_EXT                                = $81B1;
  GL_T2F_IUI_V3F_EXT                                = $81B2;
  GL_T2F_IUI_N3F_V2F_EXT                            = $81B3;
  GL_T2F_IUI_N3F_V3F_EXT                            = $81B4;

  // EXT_index_func
  GL_INDEX_TEST_EXT                                 = $81B5;
  GL_INDEX_TEST_FUNC_EXT                            = $81B6;
  GL_INDEX_TEST_REF_EXT                             = $81B7;

  // EXT_index_material
  GL_INDEX_MATERIAL_EXT                             = $81B8;
  GL_INDEX_MATERIAL_PARAMETER_EXT                   = $81B9;
  GL_INDEX_MATERIAL_FACE_EXT                        = $81BA;

  // EXT_misc_attribute
  GL_MISC_BIT_EXT                                   = 0; // not yet defined

  // EXT_scene_marker
  GL_SCENE_REQUIRED_EXT                             = 0; // not yet defined

  // EXT_shared_texture_palette
  GL_SHARED_TEXTURE_PALETTE_EXT                     = $81FB;

  // EXT_nurbs_tessellator
  GLU_NURBS_MODE_EXT                                = 100160;
  GLU_NURBS_TESSELLATOR_EXT                         = 100161;
  GLU_NURBS_RENDERER_EXT                            = 100162;
  GLU_NURBS_BEGIN_EXT                               = 100164;
  GLU_NURBS_VERTEX_EXT                              = 100165;
  GLU_NURBS_NORMAL_EXT                              = 100166;
  GLU_NURBS_COLOR_EXT                               = 100167;
  GLU_NURBS_TEX_COORD_EXT                           = 100168;
  GLU_NURBS_END_EXT                                 = 100169;
  GLU_NURBS_BEGIN_DATA_EXT                          = 100170;
  GLU_NURBS_VERTEX_DATA_EXT                         = 100171;
  GLU_NURBS_NORMAL_DATA_EXT                         = 100172;
  GLU_NURBS_COLOR_DATA_EXT                          = 100173;
  GLU_NURBS_TEX_COORD_DATA_EXT                      = 100174;
  GLU_NURBS_END_DATA_EXT                            = 100175;

  // EXT_object_space_tess
  GLU_OBJECT_PARAMETRIC_ERROR_EXT                   = 100208;
  GLU_OBJECT_PATH_LENGTH_EXT                        = 100209;

  // EXT_point_parameters
  GL_POINT_SIZE_MIN_EXT                             = $8126;
  GL_POINT_SIZE_MAX_EXT                             = $8127;
  GL_POINT_FADE_THRESHOLD_SIZE_EXT                  = $8128;
  GL_DISTANCE_ATTENUATION_EXT                       = $8129;

  // EXT_compiled_vertex_array
  GL_ARRAY_ELEMENT_LOCK_FIRST_EXT                   = $81A8;
  GL_ARRAY_ELEMENT_LOCK_COUNT_EXT                   = $81A9;

  // ARB_multitexture
  GL_ACTIVE_TEXTURE_ARB                             = $84E0;
  GL_CLIENT_ACTIVE_TEXTURE_ARB                      = $84E1;
  GL_MAX_TEXTURE_UNITS_ARB                          = $84E2;
  GL_TEXTURE0_ARB                                   = $84C0;
  GL_TEXTURE1_ARB                                   = $84C1;
  GL_TEXTURE2_ARB                                   = $84C2;
  GL_TEXTURE3_ARB                                   = $84C3;
  GL_TEXTURE4_ARB                                   = $84C4;
  GL_TEXTURE5_ARB                                   = $84C5;
  GL_TEXTURE6_ARB                                   = $84C6;
  GL_TEXTURE7_ARB                                   = $84C7;
  GL_TEXTURE8_ARB                                   = $84C8;
  GL_TEXTURE9_ARB                                   = $84C9;
  GL_TEXTURE10_ARB                                  = $84CA;
  GL_TEXTURE11_ARB                                  = $84CB;
  GL_TEXTURE12_ARB                                  = $84CC;
  GL_TEXTURE13_ARB                                  = $84CD;
  GL_TEXTURE14_ARB                                  = $84CE;
  GL_TEXTURE15_ARB                                  = $84CF;
  GL_TEXTURE16_ARB                                  = $84D0;
  GL_TEXTURE17_ARB                                  = $84D1;
  GL_TEXTURE18_ARB                                  = $84D2;
  GL_TEXTURE19_ARB                                  = $84D3;
  GL_TEXTURE20_ARB                                  = $84D4;
  GL_TEXTURE21_ARB                                  = $84D5;
  GL_TEXTURE22_ARB                                  = $84D6;
  GL_TEXTURE23_ARB                                  = $84D7;
  GL_TEXTURE24_ARB                                  = $84D8;
  GL_TEXTURE25_ARB                                  = $84D9;
  GL_TEXTURE26_ARB                                  = $84DA;
  GL_TEXTURE27_ARB                                  = $84DB;
  GL_TEXTURE28_ARB                                  = $84DC;
  GL_TEXTURE29_ARB                                  = $84DD;
  GL_TEXTURE30_ARB                                  = $84DE;
  GL_TEXTURE31_ARB                                  = $84DF;

  // EXT_stencil_wrap
  GL_INCR_WRAP_EXT                                  = $8507;
  GL_DECR_WRAP_EXT                                  = $8508;

  // NV_texgen_reflection
  GL_NORMAL_MAP_NV                                  = $8511;
  GL_REFLECTION_MAP_NV                              = $8512;

  // EXT_texture_env_combine
  GL_COMBINE_EXT                                    = $8570;
  GL_COMBINE_RGB_EXT                                = $8571;
  GL_COMBINE_ALPHA_EXT                              = $8572;
  GL_RGB_SCALE_EXT                                  = $8573;
  GL_ADD_SIGNED_EXT                                 = $8574;
  GL_INTERPOLATE_EXT                                = $8575;
  GL_CONSTANT_EXT                                   = $8576;
  GL_PRIMARY_COLOR_EXT                              = $8577;
  GL_PREVIOUS_EXT                                   = $8578;
  GL_SOURCE0_RGB_EXT                                = $8580;
  GL_SOURCE1_RGB_EXT                                = $8581;
  GL_SOURCE2_RGB_EXT                                = $8582;
  GL_SOURCE0_ALPHA_EXT                              = $8588;
  GL_SOURCE1_ALPHA_EXT                              = $8589;
  GL_SOURCE2_ALPHA_EXT                              = $858A;
  GL_OPERAND0_RGB_EXT                               = $8590;
  GL_OPERAND1_RGB_EXT                               = $8591;
  GL_OPERAND2_RGB_EXT                               = $8592;
  GL_OPERAND0_ALPHA_EXT                             = $8598;
  GL_OPERAND1_ALPHA_EXT                             = $8599;
  GL_OPERAND2_ALPHA_EXT                             = $859A;

  // NV_texture_env_combine4
  GL_COMBINE4_NV                                    = $8503;
  GL_SOURCE3_RGB_NV                                 = $8583;
  GL_SOURCE3_ALPHA_NV                               = $858B;
  GL_OPERAND3_RGB_NV                                = $8593;
  GL_OPERAND3_ALPHA_NV                              = $859B;

const
  GL_BLEND_EQUATION                                 = $8009;
  GL_TABLE_TOO_LARGE                                = $8031;
  GL_UNSIGNED_BYTE_3_3_2                            = $8032;
  GL_UNSIGNED_SHORT_4_4_4_4                         = $8033;
  GL_UNSIGNED_SHORT_5_5_5_1                         = $8034;
  GL_UNSIGNED_INT_8_8_8_8                           = $8035;
  GL_UNSIGNED_INT_10_10_10_2                        = $8036;
  GL_UNSIGNED_BYTE_2_3_3_REV                        = $8362;
  GL_UNSIGNED_SHORT_5_6_5                           = $8363;
  GL_UNSIGNED_SHORT_5_6_5_REV                       = $8364;
  GL_UNSIGNED_SHORT_4_4_4_4_REV                     = $8365;
  GL_UNSIGNED_SHORT_1_5_5_5_REV                     = $8366;
  GL_UNSIGNED_INT_8_8_8_8_REV                       = $8367;
  GL_UNSIGNED_INT_2_10_10_10_REV                    = $8368;

  // GL_ARB_transpose_matrix
  GL_TRANSPOSE_MODELVIEW_MATRIX_ARB                 = $84E3;
  GL_TRANSPOSE_PROJECTION_MATRIX_ARB                = $84E4;
  GL_TRANSPOSE_TEXTURE_MATRIX_ARB                   = $84E5;
  GL_TRANSPOSE_COLOR_MATRIX_ARB                     = $84E6;

  // GL_ARB_multisample
  GL_MULTISAMPLE_ARB                                = $809D;
  GL_SAMPLE_ALPHA_TO_COVERAGE_ARB                   = $809E;
  GL_SAMPLE_ALPHA_TO_ONE_ARB                        = $809F;
  GL_SAMPLE_COVERAGE_ARB                            = $80A0;
  GL_SAMPLE_BUFFERS_ARB                             = $80A8;
  GL_SAMPLES_ARB                                    = $80A9;
  GL_SAMPLE_COVERAGE_VALUE_ARB                      = $80AA;
  GL_SAMPLE_COVERAGE_INVERT_ARB                     = $80AB;
  GL_MULTISAMPLE_BIT_ARB                            = $20000000;

  // GL_ARB_texture_cube_map
  GL_NORMAL_MAP_ARB                                 = $8511;
  GL_REFLECTION_MAP_ARB                             = $8512;
  GL_TEXTURE_CUBE_MAP_ARB                           = $8513;
  GL_TEXTURE_BINDING_CUBE_MAP_ARB                   = $8514;
  GL_TEXTURE_CUBE_MAP_POSITIVE_X_ARB                = $8515;
  GL_TEXTURE_CUBE_MAP_NEGATIVE_X_ARB                = $8516;
  GL_TEXTURE_CUBE_MAP_POSITIVE_Y_ARB                = $8517;
  GL_TEXTURE_CUBE_MAP_NEGATIVE_Y_ARB                = $8518;
  GL_TEXTURE_CUBE_MAP_POSITIVE_Z_ARB                = $8519;
  GL_TEXTURE_CUBE_MAP_NEGATIVE_Z_ARB                = $851A;
  GL_PROXY_TEXTURE_CUBE_MAP_ARB                     = $851B;
  GL_MAX_CUBE_MAP_TEXTURE_SIZE_ARB                  = $851C;

  // GL_ARB_texture_compression
  GL_COMPRESSED_ALPHA_ARB                           = $84E9;
  GL_COMPRESSED_LUMINANCE_ARB                       = $84EA;
  GL_COMPRESSED_LUMINANCE_ALPHA_ARB                 = $84EB;
  GL_COMPRESSED_INTENSITY_ARB                       = $84EC;
  GL_COMPRESSED_RGB_ARB                             = $84ED;
  GL_COMPRESSED_RGBA_ARB                            = $84EE;
  GL_TEXTURE_COMPRESSION_HINT_ARB                   = $84EF;
  GL_TEXTURE_COMPRESSED_IMAGE_SIZE_ARB              = $86A0;
  GL_TEXTURE_COMPRESSED_ARB                         = $86A1;

  GL_NUM_COMPRESSED_TEXTURE_FORMATS_ARB             = $86A2;
  GL_COMPRESSED_TEXTURE_FORMATS_ARB                 = $86A3;

  // GL_ARB_vertex_blend
  GL_MAX_VERTEX_UNITS_ARB                           = $86A4;
  GL_ACTIVE_VERTEX_UNITS_ARB                        = $86A5;
  GL_WEIGHT_SUM_UNITY_ARB                           = $86A6;
  GL_VERTEX_BLEND_ARB                               = $86A7;
  GL_CURRENT_WEIGHT_ARB                             = $86A8;
  GL_WEIGHT_ARRAY_TYPE_ARB                          = $86A9;
  GL_WEIGHT_ARRAY_STRIDE_ARB                        = $86AA;
  GL_WEIGHT_ARRAY_SIZE_ARB                          = $86AB;
  GL_WEIGHT_ARRAY_POINTER_ARB                       = $86AC;
  GL_WEIGHT_ARRAY_ARB                               = $86AD;
  GL_MODELVIEW0_ARB                                 = $1700;
  GL_MODELVIEW1_ARB                                 = $850A;
  GL_MODELVIEW2_ARB                                 = $8722;
  GL_MODELVIEW3_ARB                                 = $8723;
  GL_MODELVIEW4_ARB                                 = $8724;
  GL_MODELVIEW5_ARB                                 = $8725;
  GL_MODELVIEW6_ARB                                 = $8726;
  GL_MODELVIEW7_ARB                                 = $8727;
  GL_MODELVIEW8_ARB                                 = $8728;
  GL_MODELVIEW9_ARB                                 = $8729;
  GL_MODELVIEW10_ARB                                = $872A;
  GL_MODELVIEW11_ARB                                = $872B;
  GL_MODELVIEW12_ARB                                = $872C;
  GL_MODELVIEW13_ARB                                = $872D;
  GL_MODELVIEW14_ARB                                = $872E;
  GL_MODELVIEW15_ARB                                = $872F;
  GL_MODELVIEW16_ARB                                = $8730;
  GL_MODELVIEW17_ARB                                = $8731;
  GL_MODELVIEW18_ARB                                = $8732;
  GL_MODELVIEW19_ARB                                = $8733;
  GL_MODELVIEW20_ARB                                = $8734;
  GL_MODELVIEW21_ARB                                = $8735;
  GL_MODELVIEW22_ARB                                = $8736;
  GL_MODELVIEW23_ARB                                = $8737;
  GL_MODELVIEW24_ARB                                = $8738;
  GL_MODELVIEW25_ARB                                = $8739;
  GL_MODELVIEW26_ARB                                = $873A;
  GL_MODELVIEW27_ARB                                = $873B;
  GL_MODELVIEW28_ARB                                = $873C;
  GL_MODELVIEW29_ARB                                = $873D;
  GL_MODELVIEW30_ARB                                = $873E;
  GL_MODELVIEW31_ARB                                = $873F;

  // GL_SGIS_texture_filter4
  GL_FILTER4_SGIS                                   = $8146;
  GL_TEXTURE_FILTER4_SIZE_SGIS                      = $8147;

  // GL_SGIS_pixel_texture
  GL_PIXEL_TEXTURE_SGIS                             = $8353;
  GL_PIXEL_FRAGMENT_RGB_SOURCE_SGIS                 = $8354;
  GL_PIXEL_FRAGMENT_ALPHA_SOURCE_SGIS               = $8355;
  GL_PIXEL_GROUP_COLOR_SGIS                         = $8356;

  // GL_SGIX_pixel_texture
  GL_PIXEL_TEX_GEN_SGIX                             = $8139;
  GL_PIXEL_TEX_GEN_MODE_SGIX                        = $832B;

  // GL_SGIS_texture4D
  GL_PACK_SKIP_VOLUMES_SGIS                         = $8130;
  GL_PACK_IMAGE_DEPTH_SGIS                          = $8131;
  GL_UNPACK_SKIP_VOLUMES_SGIS                       = $8132;
  GL_UNPACK_IMAGE_DEPTH_SGIS                        = $8133;
  GL_TEXTURE_4D_SGIS                                = $8134;
  GL_PROXY_TEXTURE_4D_SGIS                          = $8135;
  GL_TEXTURE_4DSIZE_SGIS                            = $8136;
  GL_TEXTURE_WRAP_Q_SGIS                            = $8137;
  GL_MAX_4D_TEXTURE_SIZE_SGIS                       = $8138;
  GL_TEXTURE_4D_BINDING_SGIS                        = $814F;

  // GL_SGIS_detail_texture
  GL_DETAIL_TEXTURE_2D_SGIS                         = $8095;
  GL_DETAIL_TEXTURE_2D_BINDING_SGIS                 = $8096;
  GL_LINEAR_DETAIL_SGIS                             = $8097;
  GL_LINEAR_DETAIL_ALPHA_SGIS                       = $8098;
  GL_LINEAR_DETAIL_COLOR_SGIS                       = $8099;
  GL_DETAIL_TEXTURE_LEVEL_SGIS                      = $809A;
  GL_DETAIL_TEXTURE_MODE_SGIS                       = $809B;
  GL_DETAIL_TEXTURE_FUNC_POINTS_SGIS                = $809C;

  // GL_SGIS_sharpen_texture
  GL_LINEAR_SHARPEN_SGIS                            = $80AD;
  GL_LINEAR_SHARPEN_ALPHA_SGIS                      = $80AE;
  GL_LINEAR_SHARPEN_COLOR_SGIS                      = $80AF;
  GL_SHARPEN_TEXTURE_FUNC_POINTS_SGIS               = $80B0;

  // GL_SGIS_texture_lod
  GL_TEXTURE_MIN_LOD_SGIS                           = $813A;
  GL_TEXTURE_MAX_LOD_SGIS                           = $813B;
  GL_TEXTURE_BASE_LEVEL_SGIS                        = $813C;
  GL_TEXTURE_MAX_LEVEL_SGIS                         = $813D;

  // GL_SGIS_multisample
  GL_MULTISAMPLE_SGIS                               = $809D;
  GL_SAMPLE_ALPHA_TO_MASK_SGIS                      = $809E;
  GL_SAMPLE_ALPHA_TO_ONE_SGIS                       = $809F;
  GL_SAMPLE_MASK_SGIS                               = $80A0;
  GL_1PASS_SGIS                                     = $80A1;
  GL_2PASS_0_SGIS                                   = $80A2;
  GL_2PASS_1_SGIS                                   = $80A3;
  GL_4PASS_0_SGIS                                   = $80A4;
  GL_4PASS_1_SGIS                                   = $80A5;
  GL_4PASS_2_SGIS                                   = $80A6;
  GL_4PASS_3_SGIS                                   = $80A7;
  GL_SAMPLE_BUFFERS_SGIS                            = $80A8;
  GL_SAMPLES_SGIS                                   = $80A9;
  GL_SAMPLE_MASK_VALUE_SGIS                         = $80AA;
  GL_SAMPLE_MASK_INVERT_SGIS                        = $80AB;
  GL_SAMPLE_PATTERN_SGIS                            = $80AC;

  // GL_SGIS_generate_mipmap
  GL_GENERATE_MIPMAP_SGIS                           = $8191;
  GL_GENERATE_MIPMAP_HINT_SGIS                      = $8192;

  // GL_SGIX_clipmap
  GL_LINEAR_CLIPMAP_LINEAR_SGIX                     = $8170;
  GL_TEXTURE_CLIPMAP_CENTER_SGIX                    = $8171;
  GL_TEXTURE_CLIPMAP_FRAME_SGIX                     = $8172;
  GL_TEXTURE_CLIPMAP_OFFSET_SGIX                    = $8173;
  GL_TEXTURE_CLIPMAP_VIRTUAL_DEPTH_SGIX             = $8174;
  GL_TEXTURE_CLIPMAP_LOD_OFFSET_SGIX                = $8175;
  GL_TEXTURE_CLIPMAP_DEPTH_SGIX                     = $8176;
  GL_MAX_CLIPMAP_DEPTH_SGIX                         = $8177;
  GL_MAX_CLIPMAP_VIRTUAL_DEPTH_SGIX                 = $8178;
  GL_NEAREST_CLIPMAP_NEAREST_SGIX                   = $844D;
  GL_NEAREST_CLIPMAP_LINEAR_SGIX                    = $844E;
  GL_LINEAR_CLIPMAP_NEAREST_SGIX                    = $844F;

  // GL_SGIX_shadow
  GL_TEXTURE_COMPARE_SGIX                           = $819A;
  GL_TEXTURE_COMPARE_OPERATOR_SGIX                  = $819B;
  GL_TEXTURE_LEQUAL_R_SGIX                          = $819C;
  GL_TEXTURE_GEQUAL_R_SGIX                          = $819D;

  // GL_SGIS_texture_edge_clamp
  GL_CLAMP_TO_EDGE_SGIS                             = $812F;

  // GL_SGIS_texture_border_clamp
  GL_CLAMP_TO_BORDER_SGIS                           = $812D;

  // GL_SGIX_interlace
  GL_INTERLACE_SGIX                                 = $8094;

  // GL_SGIX_pixel_tiles
  GL_PIXEL_TILE_BEST_ALIGNMENT_SGIX                 = $813E;
  GL_PIXEL_TILE_CACHE_INCREMENT_SGIX                = $813F;
  GL_PIXEL_TILE_WIDTH_SGIX                          = $8140;
  GL_PIXEL_TILE_HEIGHT_SGIX                         = $8141;
  GL_PIXEL_TILE_GRID_WIDTH_SGIX                     = $8142;
  GL_PIXEL_TILE_GRID_HEIGHT_SGIX                    = $8143;
  GL_PIXEL_TILE_GRID_DEPTH_SGIX                     = $8144;
  GL_PIXEL_TILE_CACHE_SIZE_SGIX                     = $8145;

  // GL_SGIS_texture_select
  GL_DUAL_ALPHA4_SGIS                               = $8110;
  GL_DUAL_ALPHA8_SGIS                               = $8111;
  GL_DUAL_ALPHA12_SGIS                              = $8112;
  GL_DUAL_ALPHA16_SGIS                              = $8113;
  GL_DUAL_LUMINANCE4_SGIS                           = $8114;
  GL_DUAL_LUMINANCE8_SGIS                           = $8115;
  GL_DUAL_LUMINANCE12_SGIS                          = $8116;
  GL_DUAL_LUMINANCE16_SGIS                          = $8117;
  GL_DUAL_INTENSITY4_SGIS                           = $8118;
  GL_DUAL_INTENSITY8_SGIS                           = $8119;
  GL_DUAL_INTENSITY12_SGIS                          = $811A;
  GL_DUAL_INTENSITY16_SGIS                          = $811B;
  GL_DUAL_LUMINANCE_ALPHA4_SGIS                     = $811C;
  GL_DUAL_LUMINANCE_ALPHA8_SGIS                     = $811D;
  GL_QUAD_ALPHA4_SGIS                               = $811E;
  GL_QUAD_ALPHA8_SGIS                               = $811F;
  GL_QUAD_LUMINANCE4_SGIS                           = $8120;
  GL_QUAD_LUMINANCE8_SGIS                           = $8121;
  GL_QUAD_INTENSITY4_SGIS                           = $8122;
  GL_QUAD_INTENSITY8_SGIS                           = $8123;
  GL_DUAL_TEXTURE_SELECT_SGIS                       = $8124;
  GL_QUAD_TEXTURE_SELECT_SGIS                       = $8125;

  // GL_SGIX_sprite
  GL_SPRITE_SGIX                                    = $8148;
  GL_SPRITE_MODE_SGIX                               = $8149;
  GL_SPRITE_AXIS_SGIX                               = $814A;
  GL_SPRITE_TRANSLATION_SGIX                        = $814B;
  GL_SPRITE_AXIAL_SGIX                              = $814C;
  GL_SPRITE_OBJECT_ALIGNED_SGIX                     = $814D;
  GL_SPRITE_EYE_ALIGNED_SGIX                        = $814E;

  // GL_SGIX_texture_multi_buffer
  GL_TEXTURE_MULTI_BUFFER_HINT_SGIX                 = $812E;

  // GL_SGIS_point_parameters
  GL_POINT_SIZE_MIN_SGIS                            = $8126;
  GL_POINT_SIZE_MAX_SGIS                            = $8127;
  GL_POINT_FADE_THRESHOLD_SIZE_SGIS                 = $8128;
  GL_DISTANCE_ATTENUATION_SGIS                      = $8129;

  // GL_SGIX_instruments
  GL_INSTRUMENT_BUFFER_POINTER_SGIX                 = $8180;
  GL_INSTRUMENT_MEASUREMENTS_SGIX                   = $8181;

  // GL_SGIX_texture_scale_bias
  GL_POST_TEXTURE_FILTER_BIAS_SGIX                  = $8179;
  GL_POST_TEXTURE_FILTER_SCALE_SGIX                 = $817A;
  GL_POST_TEXTURE_FILTER_BIAS_RANGE_SGIX            = $817B;
  GL_POST_TEXTURE_FILTER_SCALE_RANGE_SGIX           = $817C;

  // GL_SGIX_framezoom
  GL_FRAMEZOOM_SGIX                                 = $818B;
  GL_FRAMEZOOM_FACTOR_SGIX                          = $818C;
  GL_MAX_FRAMEZOOM_FACTOR_SGIX                      = $818D;

  // GL_FfdMaskSGIX
  GL_TEXTURE_DEFORMATION_BIT_SGIX                   = $00000001;
  GL_GEOMETRY_DEFORMATION_BIT_SGIX                  = $00000002;

  // GL_SGIX_polynomial_ffd
  GL_GEOMETRY_DEFORMATION_SGIX                      = $8194;
  GL_TEXTURE_DEFORMATION_SGIX                       = $8195;
  GL_DEFORMATIONS_MASK_SGIX                         = $8196;
  GL_MAX_DEFORMATION_ORDER_SGIX                     = $8197;

  // GL_SGIX_reference_plane
  GL_REFERENCE_PLANE_SGIX                           = $817D;
  GL_REFERENCE_PLANE_EQUATION_SGIX                  = $817E;

  // GL_SGIX_depth_texture
  GL_DEPTH_COMPONENT16_SGIX                         = $81A5;
  GL_DEPTH_COMPONENT24_SGIX                         = $81A6;
  GL_DEPTH_COMPONENT32_SGIX                         = $81A7;

  // GL_SGIS_fog_function
  GL_FOG_FUNC_SGIS                                  = $812A;
  GL_FOG_FUNC_POINTS_SGIS                           = $812B;
  GL_MAX_FOG_FUNC_POINTS_SGIS                       = $812C;

  // GL_SGIX_fog_offset
  GL_FOG_OFFSET_SGIX                                = $8198;
  GL_FOG_OFFSET_VALUE_SGIX                          = $8199;

  // GL_HP_image_transform
  GL_IMAGE_SCALE_X_HP                               = $8155;
  GL_IMAGE_SCALE_Y_HP                               = $8156;
  GL_IMAGE_TRANSLATE_X_HP                           = $8157;
  GL_IMAGE_TRANSLATE_Y_HP                           = $8158;
  GL_IMAGE_ROTATE_ANGLE_HP                          = $8159;
  GL_IMAGE_ROTATE_ORIGIN_X_HP                       = $815A;
  GL_IMAGE_ROTATE_ORIGIN_Y_HP                       = $815B;
  GL_IMAGE_MAG_FILTER_HP                            = $815C;
  GL_IMAGE_MIN_FILTER_HP                            = $815D;
  GL_IMAGE_CUBIC_WEIGHT_HP                          = $815E;
  GL_CUBIC_HP                                       = $815F;
  GL_AVERAGE_HP                                     = $8160;
  GL_IMAGE_TRANSFORM_2D_HP                          = $8161;
  GL_POST_IMAGE_TRANSFORM_COLOR_TABLE_HP            = $8162;
  GL_PROXY_POST_IMAGE_TRANSFORM_COLOR_TABLE_HP      = $8163;

  // GL_HP_convolution_border_modes
  GL_IGNORE_BORDER_HP                               = $8150;
  GL_CONSTANT_BORDER_HP                             = $8151;
  GL_REPLICATE_BORDER_HP                            = $8153;
  GL_CONVOLUTION_BORDER_COLOR_HP                    = $8154;

  // GL_SGIX_texture_add_env
  GL_TEXTURE_ENV_BIAS_SGIX                          = $80BE;

  // GL_PGI_vertex_hints
  GL_VERTEX_DATA_HINT_PGI                           = $1A22A;
  GL_VERTEX_CONSISTENT_HINT_PGI                     = $1A22B;
  GL_MATERIAL_SIDE_HINT_PGI                         = $1A22C;
  GL_MAX_VERTEX_HINT_PGI                            = $1A22D;
  GL_COLOR3_BIT_PGI                                 = $00010000;
  GL_COLOR4_BIT_PGI                                 = $00020000;
  GL_EDGEFLAG_BIT_PGI                               = $00040000;
  GL_INDEX_BIT_PGI                                  = $00080000;
  GL_MAT_AMBIENT_BIT_PGI                            = $00100000;
  GL_MAT_AMBIENT_AND_DIFFUSE_BIT_PGI                = $00200000;
  GL_MAT_DIFFUSE_BIT_PGI                            = $00400000;
  GL_MAT_EMISSION_BIT_PGI                           = $00800000;
  GL_MAT_COLOR_INDEXES_BIT_PGI                      = $01000000;
  GL_MAT_SHININESS_BIT_PGI                          = $02000000;
  GL_MAT_SPECULAR_BIT_PGI                           = $04000000;
  GL_NORMAL_BIT_PGI                                 = $08000000;
  GL_TEXCOORD1_BIT_PGI                              = $10000000;
  GL_TEXCOORD2_BIT_PGI                              = $20000000;
  GL_TEXCOORD3_BIT_PGI                              = $40000000;
  GL_TEXCOORD4_BIT_PGI                              = $80000000;
  GL_VERTEX23_BIT_PGI                               = $00000004;
  GL_VERTEX4_BIT_PGI                                = $00000008;

  // GL_PGI_misc_hints
  GL_PREFER_DOUBLEBUFFER_HINT_PGI                   = $1A1F8;
  GL_CONSERVE_MEMORY_HINT_PGI                       = $1A1FD;
  GL_RECLAIM_MEMORY_HINT_PGI                        = $1A1FE;
  GL_NATIVE_GRAPHICS_HANDLE_PGI                     = $1A202;
  GL_NATIVE_GRAPHICS_BEGIN_HINT_PGI                 = $1A203;
  GL_NATIVE_GRAPHICS_END_HINT_PGI                   = $1A204;
  GL_ALWAYS_FAST_HINT_PGI                           = $1A20C;
  GL_ALWAYS_SOFT_HINT_PGI                           = $1A20D;
  GL_ALLOW_DRAW_OBJ_HINT_PGI                        = $1A20E;
  GL_ALLOW_DRAW_WIN_HINT_PGI                        = $1A20F;
  GL_ALLOW_DRAW_FRG_HINT_PGI                        = $1A210;
  GL_ALLOW_DRAW_MEM_HINT_PGI                        = $1A211;
  GL_STRICT_DEPTHFUNC_HINT_PGI                      = $1A216;
  GL_STRICT_LIGHTING_HINT_PGI                       = $1A217;
  GL_STRICT_SCISSOR_HINT_PGI                        = $1A218;
  GL_FULL_STIPPLE_HINT_PGI                          = $1A219;
  GL_CLIP_NEAR_HINT_PGI                             = $1A220;
  GL_CLIP_FAR_HINT_PGI                              = $1A221;
  GL_WIDE_LINE_HINT_PGI                             = $1A222;
  GL_BACK_NORMALS_HINT_PGI                          = $1A223;

  // GL_EXT_paletted_texture
  GL_TEXTURE_INDEX_SIZE_EXT                         = $80ED;

  // GL_SGIX_list_priority
  GL_LIST_PRIORITY_SGIX                             = $8182;

  // GL_SGIX_ir_instrument1
  GL_IR_INSTRUMENT1_SGIX                            = $817F;

  // GL_SGIX_calligraphic_fragment
  GL_CALLIGRAPHIC_FRAGMENT_SGIX                     = $8183;

  // GL_SGIX_texture_lod_bias
  GL_TEXTURE_LOD_BIAS_S_SGIX                        = $818E;
  GL_TEXTURE_LOD_BIAS_T_SGIX                        = $818F;
  GL_TEXTURE_LOD_BIAS_R_SGIX                        = $8190;

  // GL_SGIX_shadow_ambient
  GL_SHADOW_AMBIENT_SGIX                            = $80BF;

  // GL_SGIX_ycrcb
  GL_YCRCB_422_SGIX                                 = $81BB;
  GL_YCRCB_444_SGIX                                 = $81BC;

  // GL_SGIX_fragment_lighting
  GL_FRAGMENT_LIGHTING_SGIX                         = $8400;
  GL_FRAGMENT_COLOR_MATERIAL_SGIX                   = $8401;
  GL_FRAGMENT_COLOR_MATERIAL_FACE_SGIX              = $8402;
  GL_FRAGMENT_COLOR_MATERIAL_PARAMETER_SGIX         = $8403;
  GL_MAX_FRAGMENT_LIGHTS_SGIX                       = $8404;
  GL_MAX_ACTIVE_LIGHTS_SGIX                         = $8405;
  GL_CURRENT_RASTER_NORMAL_SGIX                     = $8406;
  GL_LIGHT_ENV_MODE_SGIX                            = $8407;
  GL_FRAGMENT_LIGHT_MODEL_LOCAL_VIEWER_SGIX         = $8408;
  GL_FRAGMENT_LIGHT_MODEL_TWO_SIDE_SGIX             = $8409;
  GL_FRAGMENT_LIGHT_MODEL_AMBIENT_SGIX              = $840A;
  GL_FRAGMENT_LIGHT_MODEL_NORMAL_INTERPOLATION_SGIX = $840B;
  GL_FRAGMENT_LIGHT0_SGIX                           = $840C;
  GL_FRAGMENT_LIGHT1_SGIX                           = $840D;
  GL_FRAGMENT_LIGHT2_SGIX                           = $840E;
  GL_FRAGMENT_LIGHT3_SGIX                           = $840F;
  GL_FRAGMENT_LIGHT4_SGIX                           = $8410;
  GL_FRAGMENT_LIGHT5_SGIX                           = $8411;
  GL_FRAGMENT_LIGHT6_SGIX                           = $8412;
  GL_FRAGMENT_LIGHT7_SGIX                           = $8413;

  // GL_IBM_rasterpos_clip
  GL_RASTER_POSITION_UNCLIPPED_IBM                  = $19262;

  // GL_HP_texture_lighting
  GL_TEXTURE_LIGHTING_MODE_HP                       = $8167;
  GL_TEXTURE_POST_SPECULAR_HP                       = $8168;
  GL_TEXTURE_PRE_SPECULAR_HP                        = $8169;

  // GL_EXT_draw_range_elements
  GL_MAX_ELEMENTS_VERTICES_EXT                      = $80E8;
  GL_MAX_ELEMENTS_INDICES_EXT                       = $80E9;

  // GL_WIN_phong_shading
  GL_PHONG_WIN                                      = $80EA;
  GL_PHONG_HINT_WIN                                 = $80EB;

  // GL_WIN_specular_fog
  GL_FOG_SPECULAR_TEXTURE_WIN                       = $80EC;

  // GL_EXT_light_texture
  GL_FRAGMENT_MATERIAL_EXT                          = $8349;
  GL_FRAGMENT_NORMAL_EXT                            = $834A;
  GL_FRAGMENT_COLOR_EXT                             = $834C;
  GL_ATTENUATION_EXT                                = $834D;
  GL_SHADOW_ATTENUATION_EXT                         = $834E;
  GL_TEXTURE_APPLICATION_MODE_EXT                   = $834F;
  GL_TEXTURE_LIGHT_EXT                              = $8350;
  GL_TEXTURE_MATERIAL_FACE_EXT                      = $8351;
  GL_TEXTURE_MATERIAL_PARAMETER_EXT                 = $8352;

  // GL_SGIX_blend_alpha_minmax
  GL_ALPHA_MIN_SGIX                                 = $8320;
  GL_ALPHA_MAX_SGIX                                 = $8321;

  // GL_SGIX_async
  GL_ASYNC_MARKER_SGIX                              = $8329;

  // GL_SGIX_async_pixel
  GL_ASYNC_TEX_IMAGE_SGIX                           = $835C;
  GL_ASYNC_DRAW_PIXELS_SGIX                         = $835D;
  GL_ASYNC_READ_PIXELS_SGIX                         = $835E;
  GL_MAX_ASYNC_TEX_IMAGE_SGIX                       = $835F;
  GL_MAX_ASYNC_DRAW_PIXELS_SGIX                     = $8360;
  GL_MAX_ASYNC_READ_PIXELS_SGIX                     = $8361;

  // GL_SGIX_async_histogram
  GL_ASYNC_HISTOGRAM_SGIX                           = $832C;
  GL_MAX_ASYNC_HISTOGRAM_SGIX                       = $832D;

  // GL_INTEL_parallel_arrays
  GL_PARALLEL_ARRAYS_INTEL                          = $83F4;
  GL_VERTEX_ARRAY_PARALLEL_POINTERS_INTEL           = $83F5;
  GL_NORMAL_ARRAY_PARALLEL_POINTERS_INTEL           = $83F6;
  GL_COLOR_ARRAY_PARALLEL_POINTERS_INTEL            = $83F7;
  GL_TEXTURE_COORD_ARRAY_PARALLEL_POINTERS_INTEL    = $83F8;

  // GL_HP_occlusion_test
  GL_OCCLUSION_TEST_HP                              = $8165;
  GL_OCCLUSION_TEST_RESULT_HP                       = $8166;

  // GL_EXT_pixel_transform
  GL_PIXEL_TRANSFORM_2D_EXT                         = $8330;
  GL_PIXEL_MAG_FILTER_EXT                           = $8331;
  GL_PIXEL_MIN_FILTER_EXT                           = $8332;
  GL_PIXEL_CUBIC_WEIGHT_EXT                         = $8333;
  GL_CUBIC_EXT                                      = $8334;
  GL_AVERAGE_EXT                                    = $8335;
  GL_PIXEL_TRANSFORM_2D_STACK_DEPTH_EXT             = $8336;
  GL_MAX_PIXEL_TRANSFORM_2D_STACK_DEPTH_EXT         = $8337;
  GL_PIXEL_TRANSFORM_2D_MATRIX_EXT                  = $8338;

  // GL_EXT_separate_specular_color
  GL_LIGHT_MODEL_COLOR_CONTROL_EXT                  = $81F8;
  GL_SINGLE_COLOR_EXT                               = $81F9;
  GL_SEPARATE_SPECULAR_COLOR_EXT                    = $81FA;

  // GL_EXT_secondary_color
  GL_COLOR_SUM_EXT                                  = $8458;
  GL_CURRENT_SECONDARY_COLOR_EXT                    = $8459;
  GL_SECONDARY_COLOR_ARRAY_SIZE_EXT                 = $845A;
  GL_SECONDARY_COLOR_ARRAY_TYPE_EXT                 = $845B;
  GL_SECONDARY_COLOR_ARRAY_STRIDE_EXT               = $845C;
  GL_SECONDARY_COLOR_ARRAY_POINTER_EXT              = $845D;
  GL_SECONDARY_COLOR_ARRAY_EXT                      = $845E;

  // GL_EXT_texture_perturb_normal
  GL_PERTURB_EXT                                    = $85AE;
  GL_TEXTURE_NORMAL_EXT                             = $85AF;

  // GL_EXT_fog_coord
  GL_FOG_COORDINATE_SOURCE_EXT                      = $8450;
  GL_FOG_COORDINATE_EXT                             = $8451;
  GL_FRAGMENT_DEPTH_EXT                             = $8452;
  GL_CURRENT_FOG_COORDINATE_EXT                     = $8453;
  GL_FOG_COORDINATE_ARRAY_TYPE_EXT                  = $8454;
  GL_FOG_COORDINATE_ARRAY_STRIDE_EXT                = $8455;
  GL_FOG_COORDINATE_ARRAY_POINTER_EXT               = $8456;
  GL_FOG_COORDINATE_ARRAY_EXT                       = $8457;

  // GL_REND_screen_coordinates
  GL_SCREEN_COORDINATES_REND                        = $8490;
  GL_INVERTED_SCREEN_W_REND                         = $8491;

  // GL_EXT_coordinate_frame
  GL_TANGENT_ARRAY_EXT                              = $8439;
  GL_BINORMAL_ARRAY_EXT                             = $843A;
  GL_CURRENT_TANGENT_EXT                            = $843B;
  GL_CURRENT_BINORMAL_EXT                           = $843C;
  GL_TANGENT_ARRAY_TYPE_EXT                         = $843E;
  GL_TANGENT_ARRAY_STRIDE_EXT                       = $843F;
  GL_BINORMAL_ARRAY_TYPE_EXT                        = $8440;
  GL_BINORMAL_ARRAY_STRIDE_EXT                      = $8441;
  GL_TANGENT_ARRAY_POINTER_EXT                      = $8442;
  GL_BINORMAL_ARRAY_POINTER_EXT                     = $8443;
  GL_MAP1_TANGENT_EXT                               = $8444;
  GL_MAP2_TANGENT_EXT                               = $8445;
  GL_MAP1_BINORMAL_EXT                              = $8446;
  GL_MAP2_BINORMAL_EXT                              = $8447;

  // GL_EXT_texture_env_combine
  GL_SOURCE3_RGB_EXT                                = $8583;
  GL_SOURCE4_RGB_EXT                                = $8584;
  GL_SOURCE5_RGB_EXT                                = $8585;
  GL_SOURCE6_RGB_EXT                                = $8586;
  GL_SOURCE7_RGB_EXT                                = $8587;
  GL_SOURCE3_ALPHA_EXT                              = $858B;
  GL_SOURCE4_ALPHA_EXT                              = $858C;
  GL_SOURCE5_ALPHA_EXT                              = $858D;
  GL_SOURCE6_ALPHA_EXT                              = $858E;
  GL_SOURCE7_ALPHA_EXT                              = $858F;
  GL_OPERAND3_RGB_EXT                               = $8593;
  GL_OPERAND4_RGB_EXT                               = $8594;
  GL_OPERAND5_RGB_EXT                               = $8595;
  GL_OPERAND6_RGB_EXT                               = $8596;
  GL_OPERAND7_RGB_EXT                               = $8597;
  GL_OPERAND3_ALPHA_EXT                             = $859B;
  GL_OPERAND4_ALPHA_EXT                             = $859C;
  GL_OPERAND5_ALPHA_EXT                             = $859D;
  GL_OPERAND6_ALPHA_EXT                             = $859E;
  GL_OPERAND7_ALPHA_EXT                             = $859F;

  // GL_APPLE_specular_vector
  GL_LIGHT_MODEL_SPECULAR_VECTOR_APPLE              = $85B0;

  // GL_APPLE_transform_hint
  GL_TRANSFORM_HINT_APPLE                           = $85B1;

  // GL_SGIX_fog_scale
  GL_FOG_SCALE_SGIX                                 = $81FC;
  GL_FOG_SCALE_VALUE_SGIX                           = $81FD;

  // GL_SUNX_constant_data
  GL_UNPACK_CONSTANT_DATA_SUNX                      = $81D5;
  GL_TEXTURE_CONSTANT_DATA_SUNX                     = $81D6;

  // GL_SUN_global_alpha
  GL_GLOBAL_ALPHA_SUN                               = $81D9;
  GL_GLOBAL_ALPHA_FACTOR_SUN                        = $81DA;

  // GL_SUN_triangle_list
  GL_RESTART_SUN                                    = $01;
  GL_REPLACE_MIDDLE_SUN                             = $02;
  GL_REPLACE_OLDEST_SUN                             = $03;
  GL_TRIANGLE_LIST_SUN                              = $81D7;
  GL_REPLACEMENT_CODE_SUN                           = $81D8;
  GL_REPLACEMENT_CODE_ARRAY_SUN                     = $85C0;
  GL_REPLACEMENT_CODE_ARRAY_TYPE_SUN                = $85C1;
  GL_REPLACEMENT_CODE_ARRAY_STRIDE_SUN              = $85C2;
  GL_REPLACEMENT_CODE_ARRAY_POINTER_SUN             = $85C3;
  GL_R1UI_V3F_SUN                                   = $85C4;
  GL_R1UI_C4UB_V3F_SUN                              = $85C5;
  GL_R1UI_C3F_V3F_SUN                               = $85C6;
  GL_R1UI_N3F_V3F_SUN                               = $85C7;
  GL_R1UI_C4F_N3F_V3F_SUN                           = $85C8;
  GL_R1UI_T2F_V3F_SUN                               = $85C9;
  GL_R1UI_T2F_N3F_V3F_SUN                           = $85CA;
  GL_R1UI_T2F_C4F_N3F_V3F_SUN                       = $85CB;

  // GL_EXT_blend_func_separate
  GL_BLEND_DST_RGB_EXT                              = $80C8;
  GL_BLEND_SRC_RGB_EXT                              = $80C9;
  GL_BLEND_DST_ALPHA_EXT                            = $80CA;
  GL_BLEND_SRC_ALPHA_EXT                            = $80CB;

  // GL_INGR_color_clamp
  GL_RED_MIN_CLAMP_INGR                             = $8560;
  GL_GREEN_MIN_CLAMP_INGR                           = $8561;
  GL_BLUE_MIN_CLAMP_INGR                            = $8562;
  GL_ALPHA_MIN_CLAMP_INGR                           = $8563;
  GL_RED_MAX_CLAMP_INGR                             = $8564;
  GL_GREEN_MAX_CLAMP_INGR                           = $8565;
  GL_BLUE_MAX_CLAMP_INGR                            = $8566;
  GL_ALPHA_MAX_CLAMP_INGR                           = $8567;

  // GL_INGR_interlace_read
  GL_INTERLACE_READ_INGR                            = $8568;

  // GL_EXT_422_pixels
  GL_422_EXT                                        = $80CC;
  GL_422_REV_EXT                                    = $80CD;
  GL_422_AVERAGE_EXT                                = $80CE;
  GL_422_REV_AVERAGE_EXT                            = $80CF;

  // GL_EXT_texture_cube_map
  GL_NORMAL_MAP_EXT                                 = $8511;
  GL_REFLECTION_MAP_EXT                             = $8512;
  GL_TEXTURE_CUBE_MAP_EXT                           = $8513;
  GL_TEXTURE_BINDING_CUBE_MAP_EXT                   = $8514;
  GL_TEXTURE_CUBE_MAP_POSITIVE_X_EXT                = $8515;
  GL_TEXTURE_CUBE_MAP_NEGATIVE_X_EXT                = $8516;
  GL_TEXTURE_CUBE_MAP_POSITIVE_Y_EXT                = $8517;
  GL_TEXTURE_CUBE_MAP_NEGATIVE_Y_EXT                = $8518;
  GL_TEXTURE_CUBE_MAP_POSITIVE_Z_EXT                = $8519;
  GL_TEXTURE_CUBE_MAP_NEGATIVE_Z_EXT                = $851A;
  GL_PROXY_TEXTURE_CUBE_MAP_EXT                     = $851B;
  GL_MAX_CUBE_MAP_TEXTURE_SIZE_EXT                  = $851C;

  // GL_SUN_convolution_border_modes
  GL_WRAP_BORDER_SUN                                = $81D4;

  // GL_EXT_texture_lod_bias
  GL_MAX_TEXTURE_LOD_BIAS_EXT                       = $84FD;
  GL_TEXTURE_FILTER_CONTROL_EXT                     = $8500;
  GL_TEXTURE_LOD_BIAS_EXT                           = $8501;

  // GL_EXT_texture_filter_anisotropic
  GL_TEXTURE_MAX_ANISOTROPY_EXT                     = $84FE;
  GL_MAX_TEXTURE_MAX_ANISOTROPY_EXT                 = $84FF;

  // GL_EXT_vertex_weighting
  GL_MODELVIEW0_STACK_DEPTH_EXT                     = GL_MODELVIEW_STACK_DEPTH;
  GL_MODELVIEW1_STACK_DEPTH_EXT                     = $8502;
  GL_MODELVIEW0_MATRIX_EXT                          = GL_MODELVIEW_MATRIX;
  GL_MODELVIEW_MATRIX1_EXT                          = $8506;
  GL_VERTEX_WEIGHTING_EXT                           = $8509;
  GL_MODELVIEW0_EXT                                 = GL_MODELVIEW;
  GL_MODELVIEW1_EXT                                 = $850A;
  GL_CURRENT_VERTEX_WEIGHT_EXT                      = $850B;
  GL_VERTEX_WEIGHT_ARRAY_EXT                        = $850C;
  GL_VERTEX_WEIGHT_ARRAY_SIZE_EXT                   = $850D;
  GL_VERTEX_WEIGHT_ARRAY_TYPE_EXT                   = $850E;
  GL_VERTEX_WEIGHT_ARRAY_STRIDE_EXT                 = $850F;
  GL_VERTEX_WEIGHT_ARRAY_POINTER_EXT                = $8510;

  // GL_NV_light_max_exponent
  GL_MAX_SHININESS_NV                               = $8504;
  GL_MAX_SPOT_EXPONENT_NV                           = $8505;

  // GL_NV_vertex_array_range
  GL_VERTEX_ARRAY_RANGE_NV                          = $851D;
  GL_VERTEX_ARRAY_RANGE_LENGTH_NV                   = $851E;
  GL_VERTEX_ARRAY_RANGE_VALID_NV                    = $851F;
  GL_MAX_VERTEX_ARRAY_RANGE_ELEMENT_NV              = $8520;
  GL_VERTEX_ARRAY_RANGE_POINTER_NV                  = $8521;

  // GL_NV_register_combiners
  GL_REGISTER_COMBINERS_NV                          = $8522;
  GL_VARIABLE_A_NV                                  = $8523;
  GL_VARIABLE_B_NV                                  = $8524;
  GL_VARIABLE_C_NV                                  = $8525;
  GL_VARIABLE_D_NV                                  = $8526;
  GL_VARIABLE_E_NV                                  = $8527;
  GL_VARIABLE_F_NV                                  = $8528;
  GL_VARIABLE_G_NV                                  = $8529;
  GL_CONSTANT_COLOR0_NV                             = $852A;
  GL_CONSTANT_COLOR1_NV                             = $852B;
  GL_PRIMARY_COLOR_NV                               = $852C;
  GL_SECONDARY_COLOR_NV                             = $852D;
  GL_SPARE0_NV                                      = $852E;
  GL_SPARE1_NV                                      = $852F;
  GL_DISCARD_NV                                     = $8530;
  GL_E_TIMES_F_NV                                   = $8531;
  GL_SPARE0_PLUS_SECONDARY_COLOR_NV                 = $8532;
  GL_UNSIGNED_IDENTITY_NV                           = $8536;
  GL_UNSIGNED_INVERT_NV                             = $8537;
  GL_EXPAND_NORMAL_NV                               = $8538;
  GL_EXPAND_NEGATE_NV                               = $8539;
  GL_HALF_BIAS_NORMAL_NV                            = $853A;
  GL_HALF_BIAS_NEGATE_NV                            = $853B;
  GL_SIGNED_IDENTITY_NV                             = $853C;
  GL_SIGNED_NEGATE_NV                               = $853D;
  GL_SCALE_BY_TWO_NV                                = $853E;
  GL_SCALE_BY_FOUR_NV                               = $853F;
  GL_SCALE_BY_ONE_HALF_NV                           = $8540;
  GL_BIAS_BY_NEGATIVE_ONE_HALF_NV                   = $8541;
  GL_COMBINER_INPUT_NV                              = $8542;
  GL_COMBINER_MAPPING_NV                            = $8543;
  GL_COMBINER_COMPONENT_USAGE_NV                    = $8544;
  GL_COMBINER_AB_DOT_PRODUCT_NV                     = $8545;
  GL_COMBINER_CD_DOT_PRODUCT_NV                     = $8546;
  GL_COMBINER_MUX_SUM_NV                            = $8547;
  GL_COMBINER_SCALE_NV                              = $8548;
  GL_COMBINER_BIAS_NV                               = $8549;
  GL_COMBINER_AB_OUTPUT_NV                          = $854A;
  GL_COMBINER_CD_OUTPUT_NV                          = $854B;
  GL_COMBINER_SUM_OUTPUT_NV                         = $854C;
  GL_MAX_GENERAL_COMBINERS_NV                       = $854D;
  GL_NUM_GENERAL_COMBINERS_NV                       = $854E;
  GL_COLOR_SUM_CLAMP_NV                             = $854F;
  GL_COMBINER0_NV                                   = $8550;
  GL_COMBINER1_NV                                   = $8551;
  GL_COMBINER2_NV                                   = $8552;
  GL_COMBINER3_NV                                   = $8553;
  GL_COMBINER4_NV                                   = $8554;
  GL_COMBINER5_NV                                   = $8555;
  GL_COMBINER6_NV                                   = $8556;
  GL_COMBINER7_NV                                   = $8557;

  // GL_NV_fog_distance
  GL_FOG_DISTANCE_MODE_NV                           = $855A;
  GL_EYE_RADIAL_NV                                  = $855B;
  GL_EYE_PLANE_ABSOLUTE_NV                          = $855C;

  // GL_NV_texgen_emboss
  GL_EMBOSS_LIGHT_NV                                = $855D;
  GL_EMBOSS_CONSTANT_NV                             = $855E;
  GL_EMBOSS_MAP_NV                                  = $855F;

  // GL_EXT_texture_compression_s3tc
  GL_COMPRESSED_RGB_S3TC_DXT1_EXT                   = $83F0;
  GL_COMPRESSED_RGBA_S3TC_DXT1_EXT                  = $83F1;
  GL_COMPRESSED_RGBA_S3TC_DXT3_EXT                  = $83F2;
  GL_COMPRESSED_RGBA_S3TC_DXT5_EXT                  = $83F3;

  // GL_IBM_cull_vertex
  GL_CULL_VERTEX_IBM                                = 103050;

  // GL_IBM_vertex_array_lists
  GL_VERTEX_ARRAY_LIST_IBM                          = 103070;
  GL_NORMAL_ARRAY_LIST_IBM                          = 103071;
  GL_COLOR_ARRAY_LIST_IBM                           = 103072;
  GL_INDEX_ARRAY_LIST_IBM                           = 103073;
  GL_TEXTURE_COORD_ARRAY_LIST_IBM                   = 103074;
  GL_EDGE_FLAG_ARRAY_LIST_IBM                       = 103075;
  GL_FOG_COORDINATE_ARRAY_LIST_IBM                  = 103076;
  GL_SECONDARY_COLOR_ARRAY_LIST_IBM                 = 103077;
  GL_VERTEX_ARRAY_LIST_STRIDE_IBM                   = 103080;
  GL_NORMAL_ARRAY_LIST_STRIDE_IBM                   = 103081;
  GL_COLOR_ARRAY_LIST_STRIDE_IBM                    = 103082;
  GL_INDEX_ARRAY_LIST_STRIDE_IBM                    = 103083;
  GL_TEXTURE_COORD_ARRAY_LIST_STRIDE_IBM            = 103084;
  GL_EDGE_FLAG_ARRAY_LIST_STRIDE_IBM                = 103085;
  GL_FOG_COORDINATE_ARRAY_LIST_STRIDE_IBM           = 103086;
  GL_SECONDARY_COLOR_ARRAY_LIST_STRIDE_IBM          = 103087;

  // GL_SGIX_subsample
  GL_PACK_SUBSAMPLE_RATE_SGIX                       = $85A0;
  GL_UNPACK_SUBSAMPLE_RATE_SGIX                     = $85A1;
  GL_PIXEL_SUBSAMPLE_4444_SGIX                      = $85A2;
  GL_PIXEL_SUBSAMPLE_2424_SGIX                      = $85A3;
  GL_PIXEL_SUBSAMPLE_4242_SGIX                      = $85A4;

  // GL_SGIX_ycrcba
  GL_YCRCB_SGIX                                     = $8318;
  GL_YCRCBA_SGIX                                    = $8319;

  // GL_SGI_depth_pass_instrument
  GL_DEPTH_PASS_INSTRUMENT_SGIX                     = $8310;
  GL_DEPTH_PASS_INSTRUMENT_COUNTERS_SGIX            = $8311;
  GL_DEPTH_PASS_INSTRUMENT_MAX_SGIX                 = $8312;

  // GL_3DFX_texture_compression_FXT1
  GL_COMPRESSED_RGB_FXT1_3DFX                       = $86B0;
  GL_COMPRESSED_RGBA_FXT1_3DFX                      = $86B1;

  // GL_3DFX_multisample
  GL_MULTISAMPLE_3DFX                               = $86B2;
  GL_SAMPLE_BUFFERS_3DFX                            = $86B3;
  GL_SAMPLES_3DFX                                   = $86B4;
  GL_MULTISAMPLE_BIT_3DFX                           = $20000000;

  // GL_EXT_multisample
  GL_MULTISAMPLE_EXT                                = $809D;
  GL_SAMPLE_ALPHA_TO_MASK_EXT                       = $809E;
  GL_SAMPLE_ALPHA_TO_ONE_EXT                        = $809F;
  GL_SAMPLE_MASK_EXT                                = $80A0;
  GL_1PASS_EXT                                      = $80A1;
  GL_2PASS_0_EXT                                    = $80A2;
  GL_2PASS_1_EXT                                    = $80A3;
  GL_4PASS_0_EXT                                    = $80A4;
  GL_4PASS_1_EXT                                    = $80A5;
  GL_4PASS_2_EXT                                    = $80A6;
  GL_4PASS_3_EXT                                    = $80A7;
  GL_SAMPLE_BUFFERS_EXT                             = $80A8;
  GL_SAMPLES_EXT                                    = $80A9;
  GL_SAMPLE_MASK_VALUE_EXT                          = $80AA;
  GL_SAMPLE_MASK_INVERT_EXT                         = $80AB;
  GL_SAMPLE_PATTERN_EXT                             = $80AC;

  // GL_SGIX_vertex_preclip
  GL_VERTEX_PRECLIP_SGIX                            = $83EE;
  GL_VERTEX_PRECLIP_HINT_SGIX                       = $83EF;

  // GL_SGIX_convolution_accuracy
  GL_CONVOLUTION_HINT_SGIX                          = $8316;

  // GL_SGIX_resample
  GL_PACK_RESAMPLE_SGIX                             = $842C;
  GL_UNPACK_RESAMPLE_SGIX                           = $842D;
  GL_RESAMPLE_REPLICATE_SGIX                        = $842E;
  GL_RESAMPLE_ZERO_FILL_SGIX                        = $842F;
  GL_RESAMPLE_DECIMATE_SGIX                         = $8430;

  // GL_SGIS_point_line_texgen
  GL_EYE_DISTANCE_TO_POINT_SGIS                     = $81F0;
  GL_OBJECT_DISTANCE_TO_POINT_SGIS                  = $81F1;
  GL_EYE_DISTANCE_TO_LINE_SGIS                      = $81F2;
  GL_OBJECT_DISTANCE_TO_LINE_SGIS                   = $81F3;
  GL_EYE_POINT_SGIS                                 = $81F4;
  GL_OBJECT_POINT_SGIS                              = $81F5;
  GL_EYE_LINE_SGIS                                  = $81F6;
  GL_OBJECT_LINE_SGIS                               = $81F7;

  // GL_SGIS_texture_color_mask
  GL_TEXTURE_COLOR_WRITEMASK_SGIS                   = $81EF;

const
  // ********** GLU generic constants **********

  // Errors: (return value 0        = no error)
  GLU_INVALID_ENUM                                  = 100900;
  GLU_INVALID_VALUE                                 = 100901;
  GLU_OUT_OF_MEMORY                                 = 100902;
  GLU_INCOMPATIBLE_GL_VERSION                       = 100903;

  // StringName
  GLU_VERSION                                       = 100800;
  GLU_EXTENSIONS                                    = 100801;

  // Boolean
  GLU_TRUE                                          = GL_TRUE;
  GLU_FALSE                                         = GL_FALSE;

  // Quadric constants
  // QuadricNormal
  GLU_SMOOTH                                        = 100000;
  GLU_FLAT                                          = 100001;
  GLU_NONE                                          = 100002;

  // QuadricDrawStyle
  GLU_POINT                                         = 100010;
  GLU_LINE                                          = 100011;
  GLU_FILL                                          = 100012;
  GLU_SILHOUETTE                                    = 100013;

  // QuadricOrientation
  GLU_OUTSIDE                                       = 100020;
  GLU_INSIDE                                        = 100021;

  // Tesselation constants
  GLU_TESS_MAX_COORD                                = 1.0e150;

  // TessProperty
  GLU_TESS_WINDING_RULE                             = 100140;
  GLU_TESS_BOUNDARY_ONLY                            = 100141;
  GLU_TESS_TOLERANCE                                = 100142;

  // TessWinding
  GLU_TESS_WINDING_ODD                              = 100130;
  GLU_TESS_WINDING_NONZERO                          = 100131;
  GLU_TESS_WINDING_POSITIVE                         = 100132;
  GLU_TESS_WINDING_NEGATIVE                         = 100133;
  GLU_TESS_WINDING_ABS_GEQ_TWO                      = 100134;

  // TessCallback
  GLU_TESS_BEGIN                                    = 100100; // TGLUTessBeginProc
  GLU_TESS_VERTEX                                   = 100101; // TGLUTessVertexProc
  GLU_TESS_END                                      = 100102; // TGLUTessEndProc
  GLU_TESS_ERROR                                    = 100103; // TGLUTessErrorProc
  GLU_TESS_EDGE_FLAG                                = 100104; // TGLUTessEdgeFlagProc
  GLU_TESS_COMBINE                                  = 100105; // TGLUTessCombineProc
  GLU_TESS_BEGIN_DATA                               = 100106; // TGLUTessBeginDataProc
  GLU_TESS_VERTEX_DATA                              = 100107; // TGLUTessVertexDataProc
  GLU_TESS_END_DATA                                 = 100108; // TGLUTessEndDataProc
  GLU_TESS_ERROR_DATA                               = 100109; // TGLUTessErrorDataProc
  GLU_TESS_EDGE_FLAG_DATA                           = 100110; // TGLUTessEdgeFlagDataProc
  GLU_TESS_COMBINE_DATA                             = 100111; // TGLUTessCombineDataProc

  // TessError
  GLU_TESS_ERROR1                                   = 100151;
  GLU_TESS_ERROR2                                   = 100152;
  GLU_TESS_ERROR3                                   = 100153;
  GLU_TESS_ERROR4                                   = 100154;
  GLU_TESS_ERROR5                                   = 100155;
  GLU_TESS_ERROR6                                   = 100156;
  GLU_TESS_ERROR7                                   = 100157;
  GLU_TESS_ERROR8                                   = 100158;

  GLU_TESS_MISSING_BEGIN_POLYGON                    = GLU_TESS_ERROR1;
  GLU_TESS_MISSING_BEGIN_CONTOUR                    = GLU_TESS_ERROR2;
  GLU_TESS_MISSING_END_POLYGON                      = GLU_TESS_ERROR3;
  GLU_TESS_MISSING_END_CONTOUR                      = GLU_TESS_ERROR4;
  GLU_TESS_COORD_TOO_LARGE                          = GLU_TESS_ERROR5;
  GLU_TESS_NEED_COMBINE_CALLBACK                    = GLU_TESS_ERROR6;

  // NURBS constants

  // NurbsProperty
  GLU_AUTO_LOAD_MATRIX                              = 100200;
  GLU_CULLING                                       = 100201;
  GLU_SAMPLING_TOLERANCE                            = 100203;
  GLU_DISPLAY_MODE                                  = 100204;
  GLU_PARAMETRIC_TOLERANCE                          = 100202;
  GLU_SAMPLING_METHOD                               = 100205;
  GLU_U_STEP                                        = 100206;
  GLU_V_STEP                                        = 100207;

  // NurbsSampling
  GLU_PATH_LENGTH                                   = 100215;
  GLU_PARAMETRIC_ERROR                              = 100216;
  GLU_DOMAIN_DISTANCE                               = 100217;

  // NurbsTrim
  GLU_MAP1_TRIM_2                                   = 100210;
  GLU_MAP1_TRIM_3                                   = 100211;

  // NurbsDisplay
  GLU_OUTLINE_POLYGON                               = 100240;
  GLU_OUTLINE_PATCH                                 = 100241;

  // NurbsErrors
  GLU_NURBS_ERROR1                                  = 100251;
  GLU_NURBS_ERROR2                                  = 100252;
  GLU_NURBS_ERROR3                                  = 100253;
  GLU_NURBS_ERROR4                                  = 100254;
  GLU_NURBS_ERROR5                                  = 100255;
  GLU_NURBS_ERROR6                                  = 100256;
  GLU_NURBS_ERROR7                                  = 100257;
  GLU_NURBS_ERROR8                                  = 100258;
  GLU_NURBS_ERROR9                                  = 100259;
  GLU_NURBS_ERROR10                                 = 100260;
  GLU_NURBS_ERROR11                                 = 100261;
  GLU_NURBS_ERROR12                                 = 100262;
  GLU_NURBS_ERROR13                                 = 100263;
  GLU_NURBS_ERROR14                                 = 100264;
  GLU_NURBS_ERROR15                                 = 100265;
  GLU_NURBS_ERROR16                                 = 100266;
  GLU_NURBS_ERROR17                                 = 100267;
  GLU_NURBS_ERROR18                                 = 100268;
  GLU_NURBS_ERROR19                                 = 100269;
  GLU_NURBS_ERROR20                                 = 100270;
  GLU_NURBS_ERROR21                                 = 100271;
  GLU_NURBS_ERROR22                                 = 100272;
  GLU_NURBS_ERROR23                                 = 100273;
  GLU_NURBS_ERROR24                                 = 100274;
  GLU_NURBS_ERROR25                                 = 100275;
  GLU_NURBS_ERROR26                                 = 100276;
  GLU_NURBS_ERROR27                                 = 100277;
  GLU_NURBS_ERROR28                                 = 100278;
  GLU_NURBS_ERROR29                                 = 100279;
  GLU_NURBS_ERROR30                                 = 100280;
  GLU_NURBS_ERROR31                                 = 100281;
  GLU_NURBS_ERROR32                                 = 100282;
  GLU_NURBS_ERROR33                                 = 100283;
  GLU_NURBS_ERROR34                                 = 100284;
  GLU_NURBS_ERROR35                                 = 100285;
  GLU_NURBS_ERROR36                                 = 100286;
  GLU_NURBS_ERROR37                                 = 100287;

  // Contours types -- obsolete!
  GLU_CW                                            = 100120;
  GLU_CCW                                           = 100121;
  GLU_INTERIOR                                      = 100122;
  GLU_EXTERIOR                                      = 100123;
  GLU_UNKNOWN                                       = 100124;

  // Names without "TESS_" prefix
  GLU_BEGIN                                         = GLU_TESS_BEGIN;
  GLU_VERTEX                                        = GLU_TESS_VERTEX;
  GLU_END                                           = GLU_TESS_END;
  GLU_ERROR                                         = GLU_TESS_ERROR;
  GLU_EDGE_FLAG                                     = GLU_TESS_EDGE_FLAG;


type
  // GLU types
  TGLUNurbs = record end;
  TGLUQuadric = record end;
  TGLUTesselator = record end;

  PGLUNurbs = ^TGLUNurbs;
  PGLUQuadric = ^TGLUQuadric;
  PGLUTesselator = ^TGLUTesselator;

  // backwards compatibility
  TGLUNurbsObj = TGLUNurbs;
  TGLUQuadricObj = TGLUQuadric;
  TGLUTesselatorObj = TGLUTesselator;
  TGLUTriangulatorObj = TGLUTesselator;

  PGLUNurbsObj = PGLUNurbs;
  PGLUQuadricObj = PGLUQuadric;
  PGLUTesselatorObj = PGLUTesselator;
  PGLUTriangulatorObj = PGLUTesselator;



   // Vectors

   TVector3b  = array[0..2] of TGLbyte;
   TVector3d  = array[0..2] of TGLdouble;
   TVector3f  = array[0..2] of TGLfloat; PVector3f  = ^TVector3f; 
   TVector3i  = array[0..2] of TGLint;
   TVector3s  = array[0..2] of TGLshort;
   TVector3ub = array[0..2] of TGLubyte;
   TVector3ui = array[0..2] of TGLUint;
   TVector3us = array[0..2] of TGLUshort;
   TVector3p  = array[0..2] of Pointer;

   TVector4b  = array[0..3] of TGLbyte;
   TVector4d  = array[0..3] of TGLdouble;
   TVector4f  = array[0..3] of TGLfloat;
   TVector4i  = array[0..3] of TGLint;
   TVector4s  = array[0..3] of TGLshort;
   TVector4ub = array[0..3] of TGLubyte;
   TVector4ui = array[0..3] of TGLUint;
   TVector4us = array[0..3] of TGLUshort;
   TVector4p  = array[0..3] of Pointer;

   // matrices
   TMatrix3b  = array[0..2] of TVector3b;
   TMatrix3d  = array[0..2] of TVector3d;
   TMatrix3f  = array[0..2] of TVector3f;
   TMatrix3i  = array[0..2] of TVector3i;
   TMatrix3s  = array[0..2] of TVector3s;
   TMatrix3ub = array[0..2] of TVector3ub;
   TMatrix3ui = array[0..2] of TVector3ui;
   TMatrix3us = array[0..2] of TVector3us;

   TMatrix4b  = array[0..3] of TVector4b;
   TMatrix4d  = array[0..3] of TVector4d;
   TMatrix4f  = array[0..3] of TVector4f;
   TMatrix4i  = array[0..3] of TVector4i;
   TMatrix4s  = array[0..3] of TVector4s;
   TMatrix4ub = array[0..3] of TVector4ub;
   TMatrix4ui = array[0..3] of TVector4ui;
   TMatrix4us = array[0..3] of TVector4us;


   TVector = TVector4f; PVector = ^TVector;
   TMatrix = TMatrix4f; PMatrix = ^TMatrix;


  type MakeVector3f = type TVector3f;



  // Callback function prototypes
  // GLUQuadricCallback
  TGLUQuadricErrorProc = procedure(errorCode: TGLEnum); stdcall;

  // GLUTessCallback
  TGLUTessBeginProc = procedure(AType: TGLEnum); stdcall;
  TGLUTessEdgeFlagProc = procedure(Flag: TGLboolean); stdcall;
  TGLUTessVertexProc = procedure(VertexData: Pointer); stdcall;
  TGLUTessEndProc = procedure; stdcall;
  TGLUTessErrorProc = procedure(ErrNo: TGLEnum); stdcall;
  TGLUTessCombineProc = procedure(Coords: TVector3d; VertexData: TVector4p; Weight: TVector4f;
    OutData: PPointer); stdcall;
  TGLUTessBeginDataProc = procedure(AType: TGLEnum; UserData: Pointer); stdcall;
  TGLUTessEdgeFlagDataProc = procedure(Flag: TGLboolean; UserData: Pointer); stdcall;
  TGLUTessVertexDataProc = procedure(VertexData: Pointer; UserData: Pointer); stdcall;
  TGLUTessEndDataProc = procedure(UserData: Pointer); stdcall;
  TGLUTessErrorDataProc = procedure(ErrNo: TGLEnum; UserData: Pointer); stdcall;
  TGLUTessCombineDataProc = procedure(Coords: TVector3d; VertexData: TVector4p; Weight: TVector4f; OutData: PPointer;
    UserData: Pointer); stdcall;

  // GLUNurbsCallback
  TGLUNurbsErrorProc = procedure(ErrorCode: TGLEnum); stdcall;


Type

  _glAccum_ProcDeff = procedure(op: TGLuint; value: TGLfloat); stdcall;
  _glAlphaFunc_ProcDeff = procedure(func: TGLEnum; ref: TGLclampf); stdcall;

  _glAreTexturesResident_ProcDeff = function(n: TGLsizei; Textures: PGLuint; residences: PGLboolean): TGLboolean; stdcall;
  _glArrayElement_ProcDeff = procedure(i: TGLint); stdcall;
  _glBegin_ProcDeff = procedure(mode: TGLEnum);stdcall;
  _glBindTexture_ProcDeff = procedure(target: TGLEnum; texture: TGLuint); stdcall;
  _glBitmap_ProcDeff = procedure(width: TGLsizei; height: TGLsizei; xorig, yorig: TGLfloat; xmove: TGLfloat; ymove: TGLfloat; bitmap: Pointer); stdcall;
  _glBlendFunc_ProcDeff = procedure(sfactor: TGLEnum; dfactor: TGLEnum); stdcall;
  _glCallList_ProcDeff = procedure(list: TGLuint); stdcall;
  _glCallLists_ProcDeff = procedure(n: TGLsizei; atype: TGLEnum; lists: Pointer); stdcall;
  _glClear_ProcDeff = procedure(mask: TGLbitfield); stdcall;
  _glClearAccum_ProcDeff = procedure(red, green, blue, alpha: TGLfloat); stdcall;
  _glClearColor_ProcDeff = procedure(red, green, blue, alpha: TGLclampf); stdcall;
  _glClearDepth_ProcDeff = procedure(depth: TGLclampd); stdcall;
  _glClearIndex_ProcDeff = procedure(c: TGLfloat); stdcall;
  _glClearStencil_ProcDeff = procedure(s: TGLint ); stdcall;
  _glClipPlane_ProcDeff = procedure(plane: TGLEnum; equation: PGLdouble); stdcall;
  _glColor3b_ProcDeff = procedure(red, green, blue: TGLbyte); stdcall;
  _glColor3bv_ProcDeff = procedure(v: PGLbyte); stdcall;
  _glColor3d_ProcDeff = procedure(red, green, blue: TGLdouble); stdcall;
  _glColor3dv_ProcDeff = procedure(v: PGLdouble); stdcall;
  _glColor3f_ProcDeff = procedure(red, green, blue: TGLfloat); stdcall;
  _glColor3fv_ProcDeff = procedure(v: PGLfloat); stdcall;
  _glColor3i_ProcDeff = procedure(red, green, blue: TGLint); stdcall;
  _glColor3iv_ProcDeff = procedure(v: PGLint); stdcall;
  _glColor3s_ProcDeff = procedure(red, green, blue: TGLshort); stdcall;
  _glColor3sv_ProcDeff = procedure(v: PGLshort); stdcall;
  _glColor3ub_ProcDeff = procedure(red, green, blue: TGLubyte); stdcall;
  _glColor3ubv_ProcDeff = procedure(v: PGLubyte); stdcall;
  _glColor3ui_ProcDeff = procedure(red, green, blue: TGLuint); stdcall;
  _glColor3uiv_ProcDeff = procedure(v: PGLuint); stdcall;
  _glColor3us_ProcDeff = procedure(red, green, blue: TGLushort); stdcall;
  _glColor3usv_ProcDeff = procedure(v: PGLushort); stdcall;
  _glColor4b_ProcDeff = procedure(red, green, blue, alpha: TGLbyte); stdcall;
  _glColor4bv_ProcDeff = procedure(v: PGLbyte); stdcall;
  _glColor4d_ProcDeff = procedure(red, green, blue, alpha: TGLdouble ); stdcall;
  _glColor4dv_ProcDeff = procedure(v: PGLdouble); stdcall;
  _glColor4f_ProcDeff = procedure(red, green, blue, alpha: TGLfloat); stdcall;
  _glColor4fv_ProcDeff = procedure(v: PGLfloat); stdcall;
  _glColor4i_ProcDeff = procedure(red, green, blue, alpha: TGLint); stdcall;
  _glColor4iv_ProcDeff = procedure(v: PGLint); stdcall;
  _glColor4s_ProcDeff = procedure(red, green, blue, alpha: TGLshort); stdcall;
  _glColor4sv_ProcDeff = procedure(v: TGLshort); stdcall;
  _glColor4ub_ProcDeff = procedure(red, green, blue, alpha: TGLubyte); stdcall;
  _glColor4ubv_ProcDeff = procedure(v: PGLubyte); stdcall;
  _glColor4ui_ProcDeff = procedure(red, green, blue, alpha: TGLuint); stdcall;
  _glColor4uiv_ProcDeff = procedure(v: PGLuint); stdcall;
  _glColor4us_ProcDeff = procedure(red, green, blue, alpha: TGLushort); stdcall;
  _glColor4usv_ProcDeff = procedure(v: PGLushort); stdcall;
  _glColorMask_ProcDeff = procedure(red, green, blue, alpha: TGLboolean); stdcall;
  _glColorMaterial_ProcDeff = procedure(face: TGLEnum; mode: TGLEnum); stdcall;
  _glColorPointer_ProcDeff = procedure(size: TGLint; atype: TGLEnum; stride: TGLsizei; data: pointer); stdcall;
  _glCopyPixels_ProcDeff = procedure(x, y: TGLint; width, height: TGLsizei; atype: TGLEnum); stdcall;
  _glCopyTexImage1D_ProcDeff = procedure(target: TGLEnum; level: TGLint; internalFormat: TGLEnum; x, y: TGLint; width: TGLsizei; border: TGLint); stdcall;
  _glCopyTexImage2D_ProcDeff = procedure(target: TGLEnum; level: TGLint; internalFormat: TGLEnum; x, y: TGLint; width, height: TGLsizei; border: TGLint); stdcall;
  _glCopyTexSubImage1D_ProcDeff = procedure(target: TGLEnum; level, xoffset, x, y: TGLint; width: TGLsizei); stdcall;
  _glCopyTexSubImage2D_ProcDeff = procedure(target: TGLEnum; level, xoffset, yoffset, x, y: TGLint; width,     height: TGLsizei); stdcall;
  _glCullFace_ProcDeff = procedure(mode: TGLEnum); stdcall;
  _glDeleteLists_ProcDeff = procedure(list: TGLuint; range: TGLsizei); stdcall;
  _glDeleteTextures_ProcDeff = procedure(n: TGLsizei; textures: PGLuint); stdcall;
  _glDepthFunc_ProcDeff = procedure(func: TGLEnum); stdcall;
  _glDepthMask_ProcDeff = procedure(flag: TGLboolean); stdcall;
  _glDepthRange_ProcDeff = procedure(zNear, zFar: TGLclampd); stdcall;
  _glDisable_ProcDeff = procedure(cap: TGLEnum); stdcall;
  _glDisableClientState_ProcDeff = procedure(aarray: TGLEnum); stdcall;
  _glDrawArrays_ProcDeff = procedure(mode: TGLEnum; first: TGLint; count: TGLsizei); stdcall;
  _glDrawBuffer_ProcDeff = procedure(mode: TGLEnum); stdcall;
  _glDrawElements_ProcDeff = procedure(mode: TGLEnum; count: TGLsizei; atype: TGLEnum; indices: Pointer); stdcall;
  _glDrawPixels_ProcDeff = procedure(width, height: TGLsizei; format, atype: TGLEnum; pixels: Pointer); stdcall;
  _glEdgeFlag_ProcDeff = procedure(flag: TGLboolean); stdcall;
  _glEdgeFlagPointer_ProcDeff = procedure(stride: TGLsizei; data: pointer); stdcall;
  _glEdgeFlagv_ProcDeff = procedure(flag: PGLboolean); stdcall;
  _glEnable_ProcDeff = procedure(cap: TGLEnum); stdcall;
  _glEnableClientState_ProcDeff = procedure(aarray: TGLEnum); stdcall;
  _glEnd_ProcDeff = procedure; stdcall;
  _glEndList_ProcDeff = procedure; stdcall;
  _glEvalCoord1d_ProcDeff = procedure(u: TGLdouble); stdcall;
  _glEvalCoord1dv_ProcDeff = procedure(u: PGLdouble); stdcall;
  _glEvalCoord1f_ProcDeff = procedure(u: TGLfloat); stdcall;
  _glEvalCoord1fv_ProcDeff = procedure(u: PGLfloat); stdcall;
  _glEvalCoord2d_ProcDeff = procedure(u: TGLdouble; v: TGLdouble); stdcall;
  _glEvalCoord2dv_ProcDeff = procedure(u: PGLdouble); stdcall;
  _glEvalCoord2f_ProcDeff = procedure(u, v: TGLfloat); stdcall;
  _glEvalCoord2fv_ProcDeff = procedure(u: PGLfloat); stdcall;
  _glEvalMesh1_ProcDeff = procedure(mode: TGLEnum; i1, i2: TGLint); stdcall;
  _glEvalMesh2_ProcDeff = procedure(mode: TGLEnum; i1, i2, j1, j2: TGLint); stdcall;
  _glEvalPoint1_ProcDeff = procedure(i: TGLint); stdcall;
  _glEvalPoint2_ProcDeff = procedure(i, j: TGLint); stdcall;
  _glFeedbackBuffer_ProcDeff = procedure(size: TGLsizei; atype: TGLEnum; buffer: PGLfloat); stdcall;
  _glFinish_ProcDeff = procedure; stdcall;
  _glFlush_ProcDeff = procedure; stdcall;
  _glFogf_ProcDeff = procedure(pname: TGLEnum; param: TGLfloat); stdcall;
  _glFogfv_ProcDeff = procedure(pname: TGLEnum; params: PGLfloat); stdcall;
  _glFogi_ProcDeff = procedure(pname: TGLEnum; param: TGLint); stdcall;
  _glFogiv_ProcDeff = procedure(pname: TGLEnum; params: PGLint); stdcall;
  _glFrontFace_ProcDeff = procedure(mode: TGLEnum); stdcall;
  _glFrustum_ProcDeff = procedure(left, right, bottom, top, zNear, zFar: TGLdouble); stdcall;
  _glGenLists_ProcDeff = function(range: TGLsizei): TGLuint; stdcall;
  _glGenTextures_ProcDeff = procedure(n: TGLsizei; textures: PGLuint); stdcall;
  _glGetBooleanv_ProcDeff = procedure(pname: TGLEnum; params: PGLboolean); stdcall;
  _glGetClipPlane_ProcDeff = procedure(plane: TGLEnum; equation: PGLdouble); stdcall;
  _glGetDoublev_ProcDeff = procedure(pname: TGLEnum; params: PGLdouble); stdcall;
  _glGetError_ProcDeff = function : TGLuint; stdcall;
  _glGetFloatv_ProcDeff = procedure(pname: TGLEnum; params: PGLfloat); stdcall;
  _glGetIntegerv_ProcDeff = procedure(pname: TGLEnum; params: PGLint); stdcall;
  _glGetLightfv_ProcDeff = procedure(light, pname: TGLEnum; params: PGLfloat); stdcall;
  _glGetLightiv_ProcDeff = procedure(light, pname: TGLEnum; params: PGLint); stdcall;
  _glGetMapdv_ProcDeff = procedure(target, query: TGLEnum; v: PGLdouble); stdcall;
  _glGetMapfv_ProcDeff = procedure(target, query: TGLEnum; v: PGLfloat); stdcall;
  _glGetMapiv_ProcDeff = procedure(target, query: TGLEnum; v: PGLint); stdcall;
  _glGetMaterialfv_ProcDeff = procedure(face, pname: TGLEnum; params: PGLfloat); stdcall;
  _glGetMaterialiv_ProcDeff = procedure(face, pname: TGLEnum; params: PGLint); stdcall;
  _glGetPixelMapfv_ProcDeff = procedure(map: TGLEnum; values: PGLfloat); stdcall;
  _glGetPixelMapuiv_ProcDeff = procedure(map: TGLEnum; values: PGLuint); stdcall;
  _glGetPixelMapusv_ProcDeff = procedure(map: TGLEnum; values: PGLushort); stdcall;
  _glGetPointerv_ProcDeff = procedure(pname: TGLEnum; var params); stdcall;
  _glGetPolygonStipple_ProcDeff = procedure(mask: PGLubyte); stdcall;
  _glGetString_ProcDeff = function(name: TGLEnum): PChar; stdcall;
  _glGetTexEnvfv_ProcDeff = procedure(target, pname: TGLEnum; params: PGLfloat); stdcall;
  _glGetTexEnviv_ProcDeff = procedure(target, pname: TGLEnum; params: PGLint); stdcall;
  _glGetTexGendv_ProcDeff = procedure(coord, pname: TGLEnum; params: PGLdouble); stdcall;
  _glGetTexGenfv_ProcDeff = procedure(coord, pname: TGLEnum; params: PGLfloat); stdcall;
  _glGetTexGeniv_ProcDeff = procedure(coord, pname: TGLEnum; params: PGLint); stdcall;
  _glGetTexImage_ProcDeff = procedure(target: TGLEnum; level: TGLint; format, atype: TGLEnum; pixels: Pointer); stdcall;
  _glGetTexLevelParameterfv_ProcDeff = procedure(target: TGLEnum; level: TGLint; pname: TGLEnum; params: PGLfloat); stdcall;
  _glGetTexLevelParameteriv_ProcDeff = procedure(target: TGLEnum; level: TGLint; pname: TGLEnum; params: PGLint); stdcall;
  _glGetTexParameterfv_ProcDeff = procedure(target, pname: TGLEnum; params: PGLfloat); stdcall;
  _glGetTexParameteriv_ProcDeff = procedure(target, pname: TGLEnum; params: PGLint); stdcall;
  _glHint_ProcDeff = procedure(target, mode: TGLEnum); stdcall;
  _glIndexMask_ProcDeff = procedure(mask: TGLuint); stdcall;
  _glIndexPointer_ProcDeff = procedure(atype: TGLEnum; stride: TGLsizei; data: pointer); stdcall;
  _glIndexd_ProcDeff = procedure(c: TGLdouble); stdcall;
  _glIndexdv_ProcDeff = procedure(c: PGLdouble); stdcall;
  _glIndexf_ProcDeff = procedure(c: TGLfloat); stdcall;
  _glIndexfv_ProcDeff = procedure(c: PGLfloat); stdcall;
  _glIndexi_ProcDeff = procedure(c: TGLint); stdcall;
  _glIndexiv_ProcDeff = procedure(c: PGLint); stdcall;
  _glIndexs_ProcDeff = procedure(c: TGLshort); stdcall;
  _glIndexsv_ProcDeff = procedure(c: PGLshort); stdcall;
  _glIndexub_ProcDeff = procedure(c: TGLubyte); stdcall;
  _glIndexubv_ProcDeff = procedure(c: PGLubyte); stdcall;
  _glInitNames_ProcDeff = procedure; stdcall;
  _glInterleavedArrays_ProcDeff = procedure(format: TGLEnum; stride: TGLsizei; data: pointer); stdcall;
  _glIsEnabled_ProcDeff = function(cap: TGLEnum): TGLboolean; stdcall;
  _glIsList_ProcDeff = function(list: TGLuint): TGLboolean; stdcall;
  _glIsTexture_ProcDeff = function(texture: TGLuint): TGLboolean; stdcall;
  _glLightModelf_ProcDeff = procedure(pname: TGLEnum; param: TGLfloat); stdcall;
  _glLightModelfv_ProcDeff = procedure(pname: TGLEnum; params: PGLfloat); stdcall;
  _glLightModeli_ProcDeff = procedure(pname: TGLEnum; param: TGLint); stdcall;
  _glLightModeliv_ProcDeff = procedure(pname: TGLEnum; params: PGLint); stdcall;
  _glLightf_ProcDeff = procedure(light, pname: TGLEnum; param: TGLfloat); stdcall;
  _glLightfv_ProcDeff = procedure(light, pname: TGLEnum; params: PGLfloat); stdcall;
  _glLighti_ProcDeff = procedure(light, pname: TGLEnum; param: TGLint); stdcall;
  _glLightiv_ProcDeff = procedure(light, pname: TGLEnum; params: PGLint); stdcall;
  _glLineStipple_ProcDeff = procedure(factor: TGLint; pattern: TGLushort); stdcall;
  _glLineWidth_ProcDeff = procedure(width: TGLfloat); stdcall;
  _glListBase_ProcDeff = procedure(base: TGLuint); stdcall;
  _glLoadIdentity_ProcDeff = procedure; stdcall;
  _glLoadMatrixd_ProcDeff = procedure(m: PGLdouble); stdcall;
  _glLoadMatrixf_ProcDeff = procedure(m: PGLfloat); stdcall;
  _glLoadName_ProcDeff = procedure(name: TGLuint); stdcall;
  _glLogicOp_ProcDeff = procedure(opcode: TGLEnum); stdcall;
  _glMap1d_ProcDeff = procedure(target: TGLEnum; u1, u2: TGLdouble; stride, order: TGLint; points: PGLdouble); stdcall;
  _glMap1f_ProcDeff = procedure(target: TGLEnum; u1, u2: TGLfloat; stride, order: TGLint; points: PGLfloat);   stdcall;
  _glMap2d_ProcDeff = procedure(target: TGLEnum; u1, u2: TGLdouble; ustride, uorder: TGLint; v1, v2: TGLdouble; vstride, vorder: TGLint; points: PGLdouble); stdcall;
  _glMap2f_ProcDeff = procedure(target: TGLEnum; u1, u2: TGLfloat; ustride, uorder: TGLint; v1, v2: TGLfloat; vstride, vorder: TGLint; points: PGLfloat); stdcall;
  _glMapGrid1d_ProcDeff = procedure(un: TGLint; u1, u2: TGLdouble); stdcall;
  _glMapGrid1f_ProcDeff = procedure(un: TGLint; u1, u2: TGLfloat); stdcall;
  _glMapGrid2d_ProcDeff = procedure(un: TGLint; u1, u2: TGLdouble; vn: TGLint; v1, v2: TGLdouble); stdcall;
  _glMapGrid2f_ProcDeff = procedure(un: TGLint; u1, u2: TGLfloat; vn: TGLint; v1, v2: TGLfloat); stdcall;
  _glMaterialf_ProcDeff = procedure(face, pname: TGLEnum; param: TGLfloat); stdcall;
  _glMaterialfv_ProcDeff = procedure(face, pname: TGLEnum; params: PGLfloat); stdcall;
  _glMateriali_ProcDeff = procedure(face, pname: TGLEnum; param: TGLint); stdcall;
  _glMaterialiv_ProcDeff = procedure(face, pname: TGLEnum; params: PGLint); stdcall;
  _glMatrixMode_ProcDeff = procedure(mode: TGLEnum); stdcall;
  _glMultMatrixd_ProcDeff = procedure(m: PGLdouble); stdcall;
  _glMultMatrixf_ProcDeff = procedure(m: PGLfloat); stdcall;
  _glNewList_ProcDeff = procedure(list: TGLuint; mode: TGLEnum); stdcall;
  _glNormal3b_ProcDeff = procedure(nx, ny, nz: TGLbyte); stdcall;
  _glNormal3bv_ProcDeff = procedure(v: PGLbyte); stdcall;
  _glNormal3d_ProcDeff = procedure(nx, ny, nz: TGLdouble); stdcall;
  _glNormal3dv_ProcDeff = procedure(v: PGLdouble); stdcall;
  _glNormal3f_ProcDeff = procedure(nx, ny, nz: TGLfloat); stdcall;
  _glNormal3fv_ProcDeff = procedure(v: PGLfloat); stdcall;
  _glNormal3i_ProcDeff = procedure(nx, ny, nz: TGLint); stdcall;
  _glNormal3iv_ProcDeff = procedure(v: PGLint); stdcall;
  _glNormal3s_ProcDeff = procedure(nx, ny, nz: TGLshort); stdcall;
  _glNormal3sv_ProcDeff = procedure(v: PGLshort); stdcall;
  _glNormalPointer_ProcDeff = procedure(atype: TGLEnum; stride: TGLsizei; data: pointer); stdcall;
  _glOrtho_ProcDeff = procedure(left, right, bottom, top, zNear, zFar: TGLdouble); stdcall;
  _glPassThrough_ProcDeff = procedure(token: TGLfloat); stdcall;
  _glPixelMapfv_ProcDeff = procedure(map: TGLEnum; mapsize: TGLsizei; values: PGLfloat); stdcall;
  _glPixelMapuiv_ProcDeff = procedure(map: TGLEnum; mapsize: TGLsizei; values: PGLuint); stdcall;
  _glPixelMapusv_ProcDeff = procedure(map: TGLEnum; mapsize: TGLsizei; values: PGLushort); stdcall;
  _glPixelStoref_ProcDeff = procedure(pname: TGLEnum; param: TGLfloat); stdcall;
  _glPixelStorei_ProcDeff = procedure(pname: TGLEnum; param: TGLint); stdcall;
  _glPixelTransferf_ProcDeff = procedure(pname: TGLEnum; param: TGLfloat); stdcall;
  _glPixelTransferi_ProcDeff = procedure(pname: TGLEnum; param: TGLint); stdcall;
  _glPixelZoom_ProcDeff = procedure(xfactor, yfactor: TGLfloat); stdcall;
  _glPointSize_ProcDeff = procedure(size: TGLfloat); stdcall;
  _glPolygonMode_ProcDeff = procedure(face, mode: TGLEnum); stdcall;
  _glPolygonOffset_ProcDeff = procedure(factor, units: TGLfloat); stdcall;
  _glPolygonStipple_ProcDeff = procedure(mask: PGLubyte); stdcall;
  _glPopAttrib_ProcDeff = procedure; stdcall;
  _glPopClientAttrib_ProcDeff = procedure; stdcall;
  _glPopMatrix_ProcDeff = procedure; stdcall;
  _glPopName_ProcDeff = procedure; stdcall;
  _glPrioritizeTextures_ProcDeff = procedure(n: TGLsizei; textures: PGLuint; priorities: PGLclampf); stdcall;
  _glPushAttrib_ProcDeff = procedure(mask: TGLbitfield); stdcall;
  _glPushClientAttrib_ProcDeff = procedure(mask: TGLbitfield); stdcall;
  _glPushMatrix_ProcDeff = procedure; stdcall;
  _glPushName_ProcDeff = procedure(name: TGLuint); stdcall;
  _glRasterPos2d_ProcDeff = procedure(x, y: TGLdouble); stdcall;
  _glRasterPos2dv_ProcDeff = procedure(v: PGLdouble); stdcall;
  _glRasterPos2f_ProcDeff = procedure(x, y: TGLfloat); stdcall;
  _glRasterPos2fv_ProcDeff = procedure(v: PGLfloat); stdcall;
  _glRasterPos2i_ProcDeff = procedure(x, y: TGLint); stdcall;
  _glRasterPos2iv_ProcDeff = procedure(v: PGLint); stdcall;
  _glRasterPos2s_ProcDeff = procedure(x, y: PGLshort); stdcall;
  _glRasterPos2sv_ProcDeff = procedure(v: PGLshort); stdcall;
  _glRasterPos3d_ProcDeff = procedure(x, y, z: TGLdouble); stdcall;
  _glRasterPos3dv_ProcDeff = procedure(v: PGLdouble); stdcall;
  _glRasterPos3f_ProcDeff = procedure(x, y, z: TGLfloat); stdcall;
  _glRasterPos3fv_ProcDeff = procedure(v: PGLfloat); stdcall;
  _glRasterPos3i_ProcDeff = procedure(x, y, z: TGLint); stdcall;
  _glRasterPos3iv_ProcDeff = procedure(v: PGLint); stdcall;
  _glRasterPos3s_ProcDeff = procedure(x, y, z: TGLshort); stdcall;
  _glRasterPos3sv_ProcDeff = procedure(v: PGLshort); stdcall;
  _glRasterPos4d_ProcDeff = procedure(x, y, z, w: TGLdouble); stdcall;
  _glRasterPos4dv_ProcDeff = procedure(v: PGLdouble); stdcall;
  _glRasterPos4f_ProcDeff = procedure(x, y, z, w: TGLfloat); stdcall;
  _glRasterPos4fv_ProcDeff = procedure(v: PGLfloat); stdcall;
  _glRasterPos4i_ProcDeff = procedure(x, y, z, w: TGLint); stdcall;
  _glRasterPos4iv_ProcDeff = procedure(v: PGLint); stdcall;
  _glRasterPos4s_ProcDeff = procedure(x, y, z, w: TGLshort); stdcall;
  _glRasterPos4sv_ProcDeff = procedure(v: PGLshort); stdcall;
  _glReadBuffer_ProcDeff = procedure(mode: TGLEnum); stdcall;
  _glReadPixels_ProcDeff = procedure(x, y: TGLint; width, height: TGLsizei; format, atype: TGLEnum; pixels: Pointer); stdcall;
  _glRectd_ProcDeff = procedure(x1, y1, x2, y2: TGLdouble); stdcall;
  _glRectdv_ProcDeff = procedure(v1, v2: PGLdouble); stdcall;
  _glRectf_ProcDeff = procedure(x1, y1, x2, y2: TGLfloat); stdcall;
  _glRectfv_ProcDeff = procedure(v1, v2: PGLfloat); stdcall;
  _glRecti_ProcDeff = procedure(x1, y1, x2, y2: TGLint); stdcall;
  _glRectiv_ProcDeff = procedure(v1, v2: PGLint); stdcall;
  _glRects_ProcDeff = procedure(x1, y1, x2, y2: TGLshort); stdcall;
  _glRectsv_ProcDeff = procedure(v1, v2: PGLshort); stdcall;
  _glRenderMode_ProcDeff = function(mode: TGLEnum): TGLint; stdcall;
  _glRotated_ProcDeff = procedure(angle, x, y, z: TGLdouble); stdcall;
  _glRotatef_ProcDeff = procedure(angle, x, y, z: TGLfloat); stdcall;
  _glScaled_ProcDeff = procedure(x, y, z: TGLdouble); stdcall;
  _glScalef_ProcDeff = procedure(x, y, z: TGLfloat); stdcall;
  _glScissor_ProcDeff = procedure(x, y: TGLint; width, height: TGLsizei); stdcall;
  _glSelectBuffer_ProcDeff = procedure(size: TGLsizei; buffer: PGLuint); stdcall;
  _glShadeModel_ProcDeff = procedure(mode: TGLEnum); stdcall;
  _glStencilFunc_ProcDeff = procedure(func: TGLEnum; ref: TGLint; mask: TGLuint); stdcall;
  _glStencilMask_ProcDeff = procedure(mask: TGLuint); stdcall;
  _glStencilOp_ProcDeff = procedure(fail, zfail, zpass: TGLEnum); stdcall;
  _glTexCoord1d_ProcDeff = procedure(s: TGLdouble); stdcall;
  _glTexCoord1dv_ProcDeff = procedure(v: PGLdouble); stdcall;
  _glTexCoord1f_ProcDeff = procedure(s: TGLfloat); stdcall;
  _glTexCoord1fv_ProcDeff = procedure(v: PGLfloat); stdcall;
  _glTexCoord1i_ProcDeff = procedure(s: TGLint); stdcall;
  _glTexCoord1iv_ProcDeff = procedure(v: PGLint); stdcall;
  _glTexCoord1s_ProcDeff = procedure(s: TGLshort); stdcall;
  _glTexCoord1sv_ProcDeff = procedure(v: PGLshort); stdcall;
  _glTexCoord2d_ProcDeff = procedure(s, t: TGLdouble); stdcall;
  _glTexCoord2dv_ProcDeff = procedure(v: PGLdouble); stdcall;
  _glTexCoord2f_ProcDeff = procedure(s, t: TGLfloat); stdcall;
  _glTexCoord2fv_ProcDeff = procedure(v: PGLfloat); stdcall;
  _glTexCoord2i_ProcDeff = procedure(s, t: TGLint); stdcall;
  _glTexCoord2iv_ProcDeff = procedure(v: PGLint); stdcall;
  _glTexCoord2s_ProcDeff = procedure(s, t: TGLshort); stdcall;
  _glTexCoord2sv_ProcDeff = procedure(v: PGLshort); stdcall;
  _glTexCoord3d_ProcDeff = procedure(s, t, r: TGLdouble); stdcall;
  _glTexCoord3dv_ProcDeff = procedure(v: PGLdouble); stdcall;
  _glTexCoord3f_ProcDeff = procedure(s, t, r: TGLfloat); stdcall;
  _glTexCoord3fv_ProcDeff = procedure(v: PGLfloat); stdcall;
  _glTexCoord3i_ProcDeff = procedure(s, t, r: TGLint); stdcall;
  _glTexCoord3iv_ProcDeff = procedure(v: PGLint); stdcall;
  _glTexCoord3s_ProcDeff = procedure(s, t, r: TGLshort); stdcall;
  _glTexCoord3sv_ProcDeff = procedure(v: PGLshort); stdcall;
  _glTexCoord4d_ProcDeff = procedure(s, t, r, q: TGLdouble); stdcall;
  _glTexCoord4dv_ProcDeff = procedure(v: PGLdouble); stdcall;
  _glTexCoord4f_ProcDeff = procedure(s, t, r, q: TGLfloat); stdcall;
  _glTexCoord4fv_ProcDeff = procedure(v: PGLfloat); stdcall;
  _glTexCoord4i_ProcDeff = procedure(s, t, r, q: TGLint); stdcall;
  _glTexCoord4iv_ProcDeff = procedure(v: PGLint); stdcall;
  _glTexCoord4s_ProcDeff = procedure(s, t, r, q: TGLshort); stdcall;
  _glTexCoord4sv_ProcDeff = procedure(v: PGLshort); stdcall;
  _glTexCoordPointer_ProcDeff = procedure(size: TGLint; atype: TGLEnum; stride: TGLsizei; data: pointer); stdcall;
  _glTexEnvf_ProcDeff = procedure(target, pname: TGLEnum; param: TGLfloat); stdcall;
  _glTexEnvfv_ProcDeff = procedure(target, pname: TGLEnum; params: PGLfloat); stdcall;
  _glTexEnvi_ProcDeff = procedure(target, pname: TGLEnum; param: TGLint); stdcall;
  _glTexEnviv_ProcDeff = procedure(target, pname: TGLEnum; params: PGLint); stdcall;
  _glTexGend_ProcDeff = procedure(coord, pname: TGLEnum; param: TGLdouble); stdcall;
  _glTexGendv_ProcDeff = procedure(coord, pname: TGLEnum; params: PGLdouble); stdcall;
  _glTexGenf_ProcDeff = procedure(coord, pname: TGLEnum; param: TGLfloat); stdcall;
  _glTexGenfv_ProcDeff = procedure(coord, pname: TGLEnum; params: PGLfloat); stdcall;
  _glTexGeni_ProcDeff = procedure(coord, pname: TGLEnum; param: TGLint); stdcall;
  _glTexGeniv_ProcDeff = procedure(coord, pname: TGLEnum; params: PGLint); stdcall;
  _glTexImage1D_ProcDeff = procedure(target: TGLEnum; level, internalformat: TGLint; width: TGLsizei; border: TGLint; format, atype: TGLEnum; pixels: Pointer); stdcall;
  _glTexImage2D_ProcDeff = procedure(target: TGLEnum; level, internalformat: TGLint; width, height: TGLsizei; border: TGLint; format, atype: TGLEnum; Pixels:Pointer); stdcall;
  _glTexParameterf_ProcDeff = procedure(target, pname: TGLEnum; param: TGLfloat); stdcall;
  _glTexParameterfv_ProcDeff = procedure(target, pname: TGLEnum; params: PGLfloat); stdcall;
  _glTexParameteri_ProcDeff = procedure(target, pname: TGLEnum; param: TGLint); stdcall;
  _glTexParameteriv_ProcDeff = procedure(target, pname: TGLEnum; params: PGLint); stdcall;
  _glTexSubImage1D_ProcDeff = procedure(target: TGLEnum; level, xoffset: TGLint; width: TGLsizei; format, atype: TGLEnum; pixels: Pointer); stdcall;
  _glTexSubImage2D_ProcDeff = procedure(target: TGLEnum; level, xoffset, yoffset: TGLint; width, height: TGLsizei; format, atype: TGLEnum; pixels: Pointer); stdcall;
  _glTranslated_ProcDeff = procedure(x, y, z: TGLdouble); stdcall;
  _glTranslatef_ProcDeff = procedure(x, y, z: TGLfloat); stdcall;
  _glVertex2d_ProcDeff = procedure(x, y: TGLdouble); stdcall;
  _glVertex2dv_ProcDeff = procedure(v: PGLdouble); stdcall;
  _glVertex2f_ProcDeff = procedure(x, y: TGLfloat); stdcall;
  _glVertex2fv_ProcDeff = procedure(v: PGLfloat); stdcall;
  _glVertex2i_ProcDeff = procedure(x, y: TGLint); stdcall;
  _glVertex2iv_ProcDeff = procedure(v: PGLint); stdcall;
  _glVertex2s_ProcDeff = procedure(x, y: TGLshort); stdcall;
  _glVertex2sv_ProcDeff = procedure(v: PGLshort); stdcall;
  _glVertex3d_ProcDeff = procedure(x, y, z: TGLdouble); stdcall;
  _glVertex3dv_ProcDeff = procedure(v: PGLdouble); stdcall;
  _glVertex3f_ProcDeff = procedure(x, y, z: TGLfloat); stdcall;
  _glVertex3fv_ProcDeff = procedure(v: PGLfloat); stdcall;
  _glVertex3i_ProcDeff = procedure(x, y, z: TGLint); stdcall;
  _glVertex3iv_ProcDeff = procedure(v: PGLint); stdcall;
  _glVertex3s_ProcDeff = procedure(x, y, z: TGLshort); stdcall;
  _glVertex3sv_ProcDeff = procedure(v: PGLshort); stdcall;
  _glVertex4d_ProcDeff = procedure(x, y, z, w: TGLdouble); stdcall;
  _glVertex4dv_ProcDeff = procedure(v: PGLdouble); stdcall;
  _glVertex4f_ProcDeff = procedure(x, y, z, w: TGLfloat); stdcall;
  _glVertex4fv_ProcDeff = procedure(v: PGLfloat); stdcall;
  _glVertex4i_ProcDeff = procedure(x, y, z, w: TGLint); stdcall;
  _glVertex4iv_ProcDeff = procedure(v: PGLint); stdcall;
  _glVertex4s_ProcDeff = procedure(x, y, z, w: TGLshort); stdcall;
  _glVertex4sv_ProcDeff = procedure(v: PGLshort); stdcall;
  _glVertexPointer_ProcDeff = procedure(size: TGLint; atype: TGLEnum; stride: TGLsizei; data: pointer); stdcall;
  _glViewport_ProcDeff = procedure(x, y: TGLint; width, height: TGLsizei); stdcall;
  // window support functions
  _wglGetProcAddress_ProcDeff = function(ProcName: PChar): Pointer; stdcall;
  _wglCopyContext_ProcDeff = function(p1: HGLRC; p2: HGLRC; p3: Cardinal): BOOL; stdcall;
  _wglCreateContext_ProcDeff = function(DC: HDC): HGLRC; stdcall;
  _wglCreateLayerContext_ProcDeff = function(p1: HDC; p2: Integer): HGLRC; stdcall;
  _wglDeleteContext_ProcDeff = function(p1: HGLRC): BOOL; stdcall;
  _wglDescribeLayerPlane_ProcDeff =function(p1: HDC; p2, p3: Integer; p4: Cardinal; var p5: TLayerPlaneDescriptor): BOOL; stdcall;
  _wglGetCurrentContext_ProcDeff = function : HGLRC; stdcall;
  _wglGetCurrentDC_ProcDeff = function : HDC; stdcall;
  _wglGetLayerPaletteEntries_ProcDeff = function(p1: HDC; p2, p3, p4: Integer; var pcr): Integer; stdcall;
  _wglMakeCurrent_ProcDeff = function(DC: HDC; p2: HGLRC): BOOL; stdcall;
  _wglRealizeLayerPalette_ProcDeff = function(p1: HDC; p2: Integer; p3: BOOL): BOOL; stdcall;
  _wglSetLayerPaletteEntries_ProcDeff = function(p1: HDC; p2, p3, p4: Integer; var pcr): Integer; stdcall;
  _wglShareLists_ProcDeff = function(p1, p2: HGLRC): BOOL; stdcall;
  _wglSwapLayerBuffers_ProcDeff = function(p1: HDC; p2: Cardinal): BOOL; stdcall;
  _wglSwapMultipleBuffers_ProcDeff = function(p1: UINT; const p2: PWGLSwap): DWORD; stdcall;
  _wglUseFontBitmapsA_ProcDeff = function(DC: HDC; p2, p3, p4: DWORD): BOOL; stdcall;
  _wglUseFontOutlinesA_ProcDeff = function (p1: HDC; p2, p3, p4: DWORD; p5, p6: Single; p7: Integer;  p8: PGlyphMetricsFloat): BOOL; stdcall;
  _wglUseFontBitmapsW_ProcDeff = function(DC: HDC; p2, p3, p4: DWORD): BOOL; stdcall;
  _wglUseFontOutlinesW_ProcDeff = function (p1: HDC; p2, p3, p4: DWORD; p5, p6: Single; p7: Integer;  p8: PGlyphMetricsFloat): BOOL; stdcall;
  _wglUseFontBitmaps_ProcDeff = function(DC: HDC; p2, p3, p4: DWORD): BOOL; stdcall;
  _wglUseFontOutlines_ProcDeff = function(p1: HDC; p2, p3, p4: DWORD; p5, p6: Single; p7: Integer;  p8: PGlyphMetricsFloat): BOOL; stdcall;
  // GL 1.2
  _glDrawRangeElements_ProcDeff = procedure(mode: TGLEnum; Astart, Aend: TGLuint; count: TGLsizei; Atype: TGLEnum; indices: Pointer); stdcall;
  _glTexImage3D_ProcDeff = procedure(target: TGLEnum; level: TGLint; internalformat: TGLEnum; width, height, depth: TGLsizei;  border: TGLint; format: TGLEnum; Atype: TGLEnum; pixels: Pointer); stdcall;
  // GL 1.2 ARB imaging
  _glBlendColor_ProcDeff = procedure(red, green, blue, alpha: TGLclampf); stdcall;
  _glBlendEquation_ProcDeff = procedure(mode: TGLEnum); stdcall;
  _glColorSubTable_ProcDeff = procedure(target: TGLEnum; start, count: TGLsizei; format, Atype: TGLEnum; data: Pointer); stdcall;
  _glCopyColorSubTable_ProcDeff = procedure(target: TGLEnum; start: TGLsizei; x, y: TGLint; width: TGLsizei); stdcall;
  _glColorTable_ProcDeff = procedure(target, internalformat: TGLEnum; width: TGLsizei; format, Atype: TGLEnum; table: Pointer); stdcall;
  _glCopyColorTable_ProcDeff = procedure(target, internalformat: TGLEnum; x, y: TGLint; width: TGLsizei); stdcall;
  _glColorTableParameteriv_ProcDeff = procedure(target, pname: TGLEnum; params: PGLint); stdcall;
  _glColorTableParameterfv_ProcDeff = procedure(target, pname: TGLEnum; params: PGLfloat); stdcall;
  _glGetColorTable_ProcDeff = procedure(target, format, Atype: TGLEnum; table: Pointer); stdcall;
  _glGetColorTableParameteriv_ProcDeff = procedure(target, pname: TGLEnum; params: PGLint); stdcall;
  _glGetColorTableParameterfv_ProcDeff = procedure(target, pname: TGLEnum; params: PGLfloat); stdcall;
  _glConvolutionFilter1D_ProcDeff = procedure(target, internalformat: TGLEnum; width: TGLsizei; format, Atype: TGLEnum; image: Pointer); stdcall;
  _glConvolutionFilter2D_ProcDeff = procedure(target, internalformat: TGLEnum; width, height: TGLsizei; format, Atype: TGLEnum; image: Pointer); stdcall;
  _glCopyConvolutionFilter1D_ProcDeff = procedure(target, internalformat: TGLEnum; x, y: TGLint; width: TGLsizei); stdcall;
  _glCopyConvolutionFilter2D_ProcDeff = procedure(target, internalformat: TGLEnum; x, y: TGLint; width, height: TGLsizei); stdcall;
  _glGetConvolutionFilter_ProcDeff = procedure(target, internalformat, Atype: TGLEnum; image: Pointer); stdcall;
  _glSeparableFilter2D_ProcDeff = procedure(target, internalformat: TGLEnum; width, height: TGLsizei; format, Atype: TGLEnum; row, column: Pointer); stdcall;
  _glGetSeparableFilter_ProcDeff = procedure(target, format, Atype: TGLEnum; row, column, span: Pointer); stdcall;
  _glConvolutionParameteri_ProcDeff = procedure(target, pname: TGLEnum; param: TGLint); stdcall;
  _glConvolutionParameteriv_ProcDeff = procedure(target, pname: TGLEnum; params: PGLint); stdcall;
  _glConvolutionParameterf_ProcDeff = procedure(target, pname: TGLEnum; param: TGLfloat); stdcall;
  _glConvolutionParameterfv_ProcDeff = procedure(target, pname: TGLEnum; params: PGLfloat); stdcall;
  _glGetConvolutionParameteriv_ProcDeff = procedure(target, pname: TGLEnum; params: PGLint); stdcall;
  _glGetConvolutionParameterfv_ProcDeff = procedure(target, pname: TGLEnum; params: PGLfloat); stdcall;
  _glHistogram_ProcDeff = procedure(target: TGLEnum; width: TGLsizei; internalformat: TGLEnum; sink: TGLboolean); stdcall;
  _glResetHistogram_ProcDeff = procedure(target: TGLEnum); stdcall;
  _glGetHistogram_ProcDeff = procedure(target: TGLEnum; reset: TGLboolean; format, Atype: TGLEnum; values: Pointer); stdcall;
  _glGetHistogramParameteriv_ProcDeff = procedure(target, pname: TGLEnum; params: PGLint); stdcall;
  _glGetHistogramParameterfv_ProcDeff = procedure(target, pname: TGLEnum; params: PGLfloat); stdcall;
  _glMinmax_ProcDeff = procedure(target, internalformat: TGLEnum; sink: TGLboolean); stdcall;
  _glResetMinmax_ProcDeff = procedure(target: TGLEnum); stdcall;
  _glGetMinmax_ProcDeff = procedure(target: TGLEnum; reset: TGLboolean; format, Atype: TGLEnum; values: Pointer); stdcall;
  _glGetMinmaxParameteriv_ProcDeff = procedure(target, pname: TGLEnum; params: PGLint); stdcall;
  _glGetMinmaxParameterfv_ProcDeff = procedure(target, pname: TGLEnum; params: PGLfloat); stdcall;

  // GL utility functions and procedures
  _gluErrorString_ProcDeff = function(errCode: TGLEnum): PChar; stdcall;
  _gluGetString_ProcDeff = function(name: TGLEnum): PChar; stdcall;
  _gluOrtho2D_ProcDeff = procedure(left, right, bottom, top: TGLdouble); stdcall;
  _gluPerspective_ProcDeff = procedure(fovy, aspect, zNear, zFar: TGLdouble); stdcall;
  _gluPickMatrix_ProcDeff = procedure(x, y, width, height: TGLdouble; viewport: TVector4i); stdcall;
  _gluLookAt_ProcDeff = procedure(eyex, eyey, eyez, centerx, centery, centerz, upx, upy, upz: TGLdouble); stdcall;
  _gluProject_ProcDeff = function(objx, objy, objz: TGLdouble; modelMatrix: TMatrix4d; projMatrix: TMatrix4d; viewport: TVector4i;  winx, winy, winz: PGLdouble): TGLint; stdcall;
  _gluUnProject_ProcDeff = function(winx, winy, winz: TGLdouble; modelMatrix: TMatrix4d; projMatrix: TMatrix4d; viewport: TVector4i;  objx, objy, objz: PGLdouble): TGLint; stdcall;
  _gluScaleImage_ProcDeff = function(format: TGLEnum; widthin, heightin: TGLint; typein: TGLEnum; datain: Pointer; widthout,  heightout: TGLint; typeout: TGLEnum; dataout: Pointer): TGLint; stdcall;
  _gluBuild1DMipmaps_ProcDeff = function(target: TGLEnum; components, width: TGLint; format, atype: TGLEnum;  data: Pointer): TGLint; stdcall;
  _gluBuild2DMipmaps_ProcDeff = function(target: TGLEnum; components, width, height: TGLint; format, atype: TGLEnum; Data: Pointer): TGLint; stdcall;
  _gluNewQuadric_ProcDeff = function : PGLUquadric; stdcall;
  _gluDeleteQuadric_ProcDeff = procedure(state: PGLUquadric); stdcall;
  _gluQuadricNormals_ProcDeff = procedure(quadObject: PGLUquadric; normals: TGLEnum); stdcall;
  _gluQuadricTexture_ProcDeff = procedure(quadObject: PGLUquadric; textureCoords: TGLboolean); stdcall;
  _gluQuadricOrientation_ProcDeff = procedure(quadObject: PGLUquadric; orientation: TGLEnum); stdcall;
  _gluQuadricDrawStyle_ProcDeff = procedure(quadObject: PGLUquadric; drawStyle: TGLEnum); stdcall;
  _gluCylinder_ProcDeff = procedure(quadObject: PGLUquadric; baseRadius, topRadius, height: TGLdouble; slices,  stacks: TGLint); stdcall;
  _gluDisk_ProcDeff = procedure(quadObject: PGLUquadric; innerRadius, outerRadius: TGLdouble; slices, loops: TGLint); stdcall;
  _gluPartialDisk_ProcDeff = procedure(quadObject: PGLUquadric; innerRadius, outerRadius: TGLdouble; slices, loops: TGLint;  startAngle, sweepAngle: TGLdouble); stdcall;
  _gluSphere_ProcDeff = procedure(quadObject: PGLUquadric; radius: TGLdouble; slices, stacks: TGLint); stdcall;
  _gluQuadricCallback_ProcDeff = procedure(quadObject: PGLUquadric; which: TGLEnum; fn: TGLUQuadricErrorProc); stdcall;
  _gluNewTess_ProcDeff = function : PGLUtesselator; stdcall;
  _gluDeleteTess_ProcDeff = procedure(tess: PGLUtesselator); stdcall;
  _gluTessBeginPolygon_ProcDeff = procedure(tess: PGLUtesselator; polygon_data: Pointer); stdcall;
  _gluTessBeginContour_ProcDeff = procedure(tess: PGLUtesselator); stdcall;
  _gluTessVertex_ProcDeff = procedure(tess: PGLUtesselator; coords: TVector3d; data: Pointer); stdcall;
  _gluTessEndContour_ProcDeff = procedure(tess: PGLUtesselator); stdcall;
  _gluTessEndPolygon_ProcDeff = procedure(tess: PGLUtesselator); stdcall;
  _gluTessProperty_ProcDeff = procedure(tess: PGLUtesselator; which: TGLEnum; value: TGLdouble); stdcall;
  _gluTessNormal_ProcDeff = procedure(tess: PGLUtesselator; x, y, z: TGLdouble); stdcall;
  _gluTessCallback_ProcDeff = procedure(tess: PGLUtesselator; which: TGLEnum; fn: Pointer); stdcall;
  _gluGetTessProperty_ProcDeff = procedure(tess: PGLUtesselator; which: TGLEnum; value: PGLdouble); stdcall;
  _gluNewNurbsRenderer_ProcDeff = function : PGLUnurbs; stdcall;
  _gluDeleteNurbsRenderer_ProcDeff = procedure(nobj: PGLUnurbs); stdcall;
  _gluBeginSurface_ProcDeff = procedure(nobj: PGLUnurbs); stdcall;
  _gluBeginCurve_ProcDeff = procedure(nobj: PGLUnurbs); stdcall;
  _gluEndCurve_ProcDeff = procedure(nobj: PGLUnurbs); stdcall;
  _gluEndSurface_ProcDeff = procedure(nobj: PGLUnurbs); stdcall;
  _gluBeginTrim_ProcDeff = procedure(nobj: PGLUnurbs); stdcall;
  _gluEndTrim_ProcDeff = procedure(nobj: PGLUnurbs); stdcall;
  _gluPwlCurve_ProcDeff = procedure(nobj: PGLUnurbs; count: TGLint; points: PGLfloat; stride: TGLint; atype: TGLEnum); stdcall;
  _gluNurbsCurve_ProcDeff = procedure(nobj: PGLUnurbs; nknots: TGLint; knot: PGLfloat; stride: TGLint; ctlarray: PGLfloat;  order: TGLint; atype: TGLEnum); stdcall;
  _gluNurbsSurface_ProcDeff = procedure(nobj: PGLUnurbs; sknot_count: TGLint; sknot: PGLfloat; tknot_count: TGLint;  tknot: PGLfloat; s_stride, t_stride: TGLint; ctlarray: PGLfloat; sorder, torder: TGLint; atype: TGLEnum); stdcall;
  _gluLoadSamplingMatrices_ProcDeff = procedure(nobj: PGLUnurbs; modelMatrix, projMatrix: TMatrix4f; viewport: TVector4i); stdcall;
  _gluNurbsProperty_ProcDeff = procedure(nobj: PGLUnurbs; aproperty: TGLEnum; value: TGLfloat); stdcall;
  _gluGetNurbsProperty_ProcDeff = procedure(nobj: PGLUnurbs; aproperty: TGLEnum; value: PGLfloat); stdcall;
  _gluNurbsCallback_ProcDeff = procedure(nobj: PGLUnurbs; which: TGLEnum; fn: TGLUNurbsErrorProc); stdcall;
  _gluBeginPolygon_ProcDeff = procedure(tess: PGLUtesselator); stdcall;
  _gluNextContour_ProcDeff = procedure(tess: PGLUtesselator; atype: TGLEnum); stdcall;
  _gluEndPolygon_ProcDeff = procedure(tess: PGLUtesselator); stdcall;



// Extensions (gl)
function GL_3DFX_multisample:boolean;
function GL_3DFX_tbuffer: boolean;
function GL_3DFX_texture_compression_FXT1: boolean;
function GL_APPLE_specular_vector: boolean;
function GL_APPLE_transform_hint: boolean;
function GL_ARB_imaging: boolean;
function GL_ARB_multisample: boolean;
function GL_ARB_multitexture: boolean;
function GL_ARB_texture_compression: boolean;
function GL_ARB_texture_cube_map: boolean;
function GL_ARB_transpose_matrix: boolean;
function GL_ARB_vertex_blend: boolean;
function GL_EXT_422_pixels: boolean;
function GL_EXT_abgr: boolean;
function GL_EXT_bgra: boolean;
function GL_EXT_blend_color: boolean;
function GL_EXT_blend_func_separate: boolean;
function GL_EXT_blend_logic_op: boolean;
function GL_EXT_blend_minmax: boolean;
function GL_EXT_blend_subtract: boolean;
function GL_EXT_clip_volume_hint: boolean;
function GL_EXT_cmyka: boolean;
function GL_EXT_color_subtable: boolean;
function GL_EXT_compiled_vertex_array: boolean;
function GL_EXT_convolution: boolean;
function GL_EXT_coordinate_frame: boolean;
function GL_EXT_copy_texture: boolean;
function GL_EXT_cull_vertex: boolean;
function GL_EXT_draw_range_elements: boolean;
function GL_EXT_fog_coord: boolean;
function GL_EXT_histogram: boolean;
function GL_EXT_index_array_formats: boolean;
function GL_EXT_index_func: boolean;
function GL_EXT_index_material: boolean;
function GL_EXT_index_texture: boolean;
function GL_EXT_light_max_exponent: boolean;
function GL_EXT_light_texture: boolean;
function GL_EXT_misc_attribute: boolean;
function GL_EXT_multi_draw_arrays: boolean;
function GL_EXT_multisample: boolean;
function GL_EXT_packed_pixels: boolean;
function GL_EXT_paletted_texture: boolean;
function GL_EXT_pixel_transform: boolean;
function GL_EXT_point_parameters: boolean;
function GL_EXT_polygon_offset: boolean;
function GL_EXT_rescale_normal: boolean;
function GL_EXT_scene_marker: boolean;
function GL_EXT_secondary_color: boolean;
function GL_EXT_separate_specular_color: boolean;
function GL_EXT_shared_texture_palette: boolean;
function GL_EXT_stencil_wrap: boolean;
function GL_EXT_subtexture: boolean;
function GL_EXT_texture_color_table: boolean;
function GL_EXT_texture_compression_s3tc: boolean;
function GL_EXT_texture_cube_map: boolean;
function GL_EXT_texture_edge_clamp: boolean;
function GL_EXT_texture_env_add: boolean;
function GL_EXT_texture_env_combine: boolean;
function GL_EXT_texture_filter_anisotropic: boolean;
function GL_EXT_texture_lod_bias: boolean;
function GL_EXT_texture_object: boolean;
function GL_EXT_texture_perturb_normal: boolean;
function GL_EXT_texture3D: boolean;
function GL_EXT_vertex_array: boolean;
function GL_EXT_vertex_weighting: boolean;
function GL_FfdMaskSGIX: boolean;
function GL_HP_convolution_border_modes: boolean;
function GL_HP_image_transform: boolean;
function GL_HP_occlusion_test: boolean;
function GL_HP_texture_lighting: boolean;
function GL_IBM_cull_vertex: boolean;
function GL_IBM_multimode_draw_arrays: boolean;
function GL_IBM_rasterpos_clip: boolean;
function GL_IBM_vertex_array_lists: boolean;
function GL_INGR_color_clamp: boolean;
function GL_INGR_interlace_read: boolean;
function GL_INTEL_parallel_arrays: boolean;
function GL_KTX_buffer_region: boolean;
function GL_MESA_resize_buffers: boolean;
function GL_MESA_window_pos: boolean;
function GL_NV_blend_square: boolean;
function GL_NV_fog_distance: boolean;
function GL_NV_light_max_exponent: boolean;
function GL_NV_register_combiners: boolean;
function GL_NV_texgen_emboss: boolean;
function GL_NV_texgen_reflection: boolean;
function GL_NV_texture_env_combine4: boolean;
function GL_NV_vertex_array_range: boolean;
function GL_PGI_misc_hints: boolean;
function GL_PGI_vertex_hints: boolean;
function GL_REND_screen_coordinates: boolean;
function GL_SGI_color_matrix: boolean;
function GL_SGI_color_table: boolean;
function GL_SGI_depth_pass_instrument: boolean;
function GL_SGIS_detail_texture: boolean;
function GL_SGIS_fog_function: boolean;
function GL_SGIS_generate_mipmap: boolean;
function GL_SGIS_multisample: boolean;
function GL_SGIS_multitexture: boolean;
function GL_SGIS_pixel_texture: boolean;
function GL_SGIS_point_line_texgen: boolean;
function GL_SGIS_point_parameters: boolean;
function GL_SGIS_sharpen_texture: boolean;
function GL_SGIS_texture_border_clamp: boolean;
function GL_SGIS_texture_color_mask: boolean;
function GL_SGIS_texture_edge_clamp: boolean;
function GL_SGIS_texture_filter4: boolean;
function GL_SGIS_texture_lod: boolean;
function GL_SGIS_texture_select: boolean;
function GL_SGIS_texture4D: boolean;
function GL_SGIX_async: boolean;
function GL_SGIX_async_histogram: boolean;
function GL_SGIX_async_pixel: boolean;
function GL_SGIX_blend_alpha_minmax: boolean;
function GL_SGIX_calligraphic_fragment: boolean;
function GL_SGIX_clipmap: boolean;
function GL_SGIX_convolution_accuracy: boolean;
function GL_SGIX_depth_texture: boolean;
function GL_SGIX_flush_raster: boolean;
function GL_SGIX_fog_offset: boolean;
function GL_SGIX_fog_scale: boolean;
function GL_SGIX_fragment_lighting: boolean;
function GL_SGIX_framezoom: boolean;
function GL_SGIX_igloo_interface: boolean;
function GL_SGIX_instruments: boolean;
function GL_SGIX_interlace: boolean;
function GL_SGIX_ir_instrument1: boolean;
function GL_SGIX_list_priority: boolean;
function GL_SGIX_pixel_texture: boolean;
function GL_SGIX_pixel_tiles: boolean;
function GL_SGIX_polynomial_ffd: boolean;
function GL_SGIX_reference_plane: boolean;
function GL_SGIX_resample: boolean;
function GL_SGIX_shadow: boolean;
function GL_SGIX_shadow_ambient: boolean;
function GL_SGIX_sprite: boolean;
function GL_SGIX_subsample: boolean;
function GL_SGIX_tag_sample_buffer: boolean;
function GL_SGIX_texture_add_env: boolean;
function GL_SGIX_texture_lod_bias: boolean;
function GL_SGIX_texture_multi_buffer: boolean;
function GL_SGIX_texture_scale_bias: boolean;
function GL_SGIX_vertex_preclip: boolean;
function GL_SGIX_ycrcb: boolean;
function GL_SGIX_ycrcba: boolean;
function GL_SUN_convolution_border_modes: boolean;
function GL_SUN_global_alpha: boolean;
function GL_SUN_triangle_list: boolean;
function GL_SUN_vertex: boolean;
function GL_SUNX_constant_data: boolean;
function GL_WIN_phong_shading: boolean;
function GL_WIN_specular_fog: boolean;
function GL_WIN_swap_hint: boolean;
function WGL_EXT_swap_control: boolean;
// Extensions (glu)
function GLU_EXT_Texture: boolean;
function GLU_EXT_object_space_tess: boolean;
function GLU_EXT_nurbs_tessellator: boolean;


procedure _Init_glAccum;
procedure _Init_glAlphaFunc;
procedure _Init_glAreTexturesResident;
procedure _Init_glArrayElement;
procedure _Init_glBegin;
procedure _Init_glBindTexture;
procedure _Init_glBitmap;
procedure _Init_glBlendFunc;
procedure _Init_glCallList;
procedure _Init_glCallLists;
procedure _Init_glClear;
procedure _Init_glClearAccum;
procedure _Init_glClearColor;
procedure _Init_glClearDepth;
procedure _Init_glClearIndex;
procedure _Init_glClearStencil;
procedure _Init_glClipPlane;
procedure _Init_glColor3b;
procedure _Init_glColor3bv;
procedure _Init_glColor3d;
procedure _Init_glColor3dv;
procedure _Init_glColor3f;
procedure _Init_glColor3fv;
procedure _Init_glColor3i;
procedure _Init_glColor3iv;
procedure _init_glcolor3s;
procedure _Init_glColor3sv;
procedure _Init_glColor3ub;
procedure _Init_glColor3ubv;
procedure _init_glcolor3ui;
procedure _Init_glColor3uiv;
procedure _Init_glColor3us;
procedure _Init_glColor3usv;
procedure _Init_glColor4b;
procedure _Init_glColor4bv;
procedure _Init_glColor4d;
procedure _Init_glColor4dv;
procedure _Init_glColor4f;
procedure _Init_glColor4fv;
procedure _Init_glColor4i;
procedure _Init_glColor4iv;
procedure _Init_glColor4s;
procedure _Init_glColor4sv;
procedure _Init_glColor4ub;
procedure _Init_glColor4ubv;
procedure _Init_glColor4ui;
procedure _Init_glColor4uiv;
procedure _Init_glColor4us;
procedure _Init_glColor4usv;
procedure _Init_glColorMask;
procedure _Init_glColorMaterial;
procedure _Init_glColorPointer;
procedure _Init_glCopyPixels;
procedure _Init_glCopyTexImage1D;
procedure _Init_glCopyTexImage2D;
procedure _Init_glCopyTexSubImage1D;
procedure _Init_glCopyTexSubImage2D;
procedure _Init_glCullFace;
procedure _Init_glDeleteLists;
procedure _Init_glDeleteTextures;
procedure _Init_glDepthFunc;
procedure _Init_glDepthMask;
procedure _Init_glDepthRange;
procedure _Init_glDisable;
procedure _Init_glDisableClientState;
procedure _Init_glDrawArrays;
procedure _Init_glDrawBuffer;
procedure _Init_glDrawElements;
procedure _Init_glDrawPixels;
procedure _Init_glEdgeFlag;
procedure _Init_glEdgeFlagPointer;
procedure _Init_glEdgeFlagv;
procedure _Init_glEnable;
procedure _Init_glEnableClientState;
procedure _Init_glEnd;
procedure _Init_glEndList;
procedure _Init_glEvalCoord1d;
procedure _Init_glEvalCoord1dv;
procedure _Init_glEvalCoord1f;
procedure _Init_glEvalCoord1fv;
procedure _Init_glEvalCoord2d;
procedure _Init_glEvalCoord2dv;
procedure _Init_glEvalCoord2f;
procedure _Init_glEvalCoord2fv;
procedure _Init_glEvalMesh1;
procedure _Init_glEvalMesh2;
procedure _Init_glEvalPoint1;
procedure _Init_glEvalPoint2;
procedure _Init_glFeedbackBuffer;
procedure _Init_glFinish;
procedure _Init_glFlush;
procedure _Init_glFogf;
procedure _Init_glFogfv;
procedure _Init_glFogi;
procedure _Init_glFogiv;
procedure _Init_glFrontFace;
procedure _Init_glFrustum;
procedure _Init_glGenLists;
procedure _Init_glGenTextures;
procedure _Init_glGetBooleanv;
procedure _Init_glGetClipPlane;
procedure _Init_glGetDoublev;
procedure _Init_glGetError;
procedure _Init_glGetFloatv;
procedure _Init_glGetIntegerv;
procedure _Init_glGetLightfv;
procedure _Init_glGetLightiv;
procedure _Init_glGetMapdv;
procedure _Init_glGetMapfv;
procedure _Init_glGetMapiv;
procedure _Init_glGetMaterialfv;
procedure _Init_glGetMaterialiv;
procedure _Init_glGetPixelMapfv;
procedure _Init_glGetPixelMapuiv;
procedure _Init_glGetPixelMapusv;
procedure _Init_glGetPointerv;
procedure _Init_glGetPolygonStipple;
procedure _Init_glGetString;
procedure _Init_glGetTexEnvfv;
procedure _Init_glGetTexEnviv;
procedure _Init_glGetTexGendv;
procedure _Init_glGetTexGenfv;
procedure _Init_glGetTexGeniv;
procedure _Init_glGetTexImage;
procedure _Init_glGetTexLevelParameterfv;
procedure _Init_glGetTexLevelParameteriv;
procedure _Init_glGetTexParameterfv;
procedure _Init_glGetTexParameteriv;
procedure _Init_glHint;
procedure _Init_glIndexMask;
procedure _Init_glIndexPointer;
procedure _Init_glIndexd;
procedure _Init_glIndexdv;
procedure _Init_glIndexf;
procedure _Init_glIndexfv;
procedure _Init_glIndexi;
procedure _Init_glIndexiv;
procedure _Init_glIndexs;
procedure _Init_glIndexsv;
procedure _Init_glIndexub;
procedure _Init_glIndexubv;
procedure _Init_glInitNames;
procedure _Init_glInterleavedArrays;
procedure _Init_glIsEnabled;
procedure _Init_glIsList;
procedure _Init_glIsTexture;
procedure _Init_glLightModelf;
procedure _Init_glLightModelfv;
procedure _Init_glLightModeli;
procedure _Init_glLightModeliv;
procedure _Init_glLightf;
procedure _Init_glLightfv;
procedure _Init_glLighti;
procedure _Init_glLightiv;
procedure _Init_glLineStipple;
procedure _Init_glLineWidth;
procedure _Init_glListBase;
procedure _Init_glLoadIdentity;
procedure _Init_glLoadMatrixd;
procedure _Init_glLoadMatrixf;
procedure _Init_glLoadName;
procedure _Init_glLogicOp;
procedure _Init_glMap1d;
procedure _Init_glMap1f;
procedure _Init_glMap2d;
procedure _Init_glMap2f;
procedure _Init_glMapGrid1d;
procedure _Init_glMapGrid1f;
procedure _Init_glMapGrid2d;
procedure _Init_glMapGrid2f;
procedure _Init_glMaterialf;
procedure _Init_glMaterialfv;
procedure _Init_glMateriali;
procedure _Init_glMaterialiv;
procedure _Init_glMatrixMode;
procedure _Init_glMultMatrixd;
procedure _Init_glMultMatrixf;
procedure _Init_glNewList;
procedure _Init_glNormal3b;
procedure _Init_glNormal3bv;
procedure _Init_glNormal3d;
procedure _Init_glNormal3dv;
procedure _Init_glNormal3f;
procedure _Init_glNormal3fv;
procedure _Init_glNormal3i;
procedure _Init_glNormal3iv;
procedure _Init_glNormal3s;
procedure _Init_glNormal3sv;
procedure _Init_glNormalPointer;
procedure _Init_glOrtho;
procedure _Init_glPassThrough;
procedure _Init_glPixelMapfv;
procedure _Init_glPixelMapuiv;
procedure _Init_glPixelMapusv;
procedure _Init_glPixelStoref;
procedure _Init_glPixelStorei;
procedure _Init_glPixelTransferf;
procedure _Init_glPixelTransferi;
procedure _Init_glPixelZoom;
procedure _Init_glPointSize;
procedure _Init_glPolygonMode;
procedure _Init_glPolygonOffset;
procedure _Init_glPolygonStipple;
procedure _Init_glPopAttrib;
procedure _Init_glPopClientAttrib;
procedure _Init_glPopMatrix;
procedure _Init_glPopName;
procedure _Init_glPrioritizeTextures;
procedure _Init_glPushAttrib;
procedure _Init_glPushClientAttrib;
procedure _Init_glPushMatrix;
procedure _Init_glPushName;
procedure _Init_glRasterPos2d;
procedure _Init_glRasterPos2dv;
procedure _Init_glRasterPos2f;
procedure _Init_glRasterPos2fv;
procedure _Init_glRasterPos2i;
procedure _Init_glRasterPos2iv;
procedure _Init_glRasterPos2s;
procedure _Init_glRasterPos2sv;
procedure _Init_glRasterPos3d;
procedure _Init_glRasterPos3dv;
procedure _Init_glRasterPos3f;
procedure _Init_glRasterPos3fv;
procedure _Init_glRasterPos3i;
procedure _Init_glRasterPos3iv;
procedure _Init_glRasterPos3s;
procedure _Init_glRasterPos3sv;
procedure _Init_glRasterPos4d;
procedure _Init_glRasterPos4dv;
procedure _Init_glRasterPos4f;
procedure _Init_glRasterPos4fv;
procedure _Init_glRasterPos4i;
procedure _Init_glRasterPos4iv;
procedure _Init_glRasterPos4s;
procedure _Init_glRasterPos4sv;
procedure _Init_glReadBuffer;
procedure _Init_glReadPixels;
procedure _Init_glRectd;
procedure _Init_glRectdv;
procedure _Init_glRectf;
procedure _Init_glRectfv;
procedure _Init_glRecti;
procedure _Init_glRectiv;
procedure _Init_glRects;
procedure _Init_glRectsv;
procedure _Init_glRenderMode;
procedure _Init_glRotated;
procedure _Init_glRotatef;
procedure _Init_glScaled;
procedure _Init_glScalef;
procedure _Init_glScissor;
procedure _Init_glSelectBuffer;
procedure _Init_glShadeModel;
procedure _Init_glStencilFunc;
procedure _Init_glStencilMask;
procedure _Init_glStencilOp;
procedure _Init_glTexCoord1d;
procedure _Init_glTexCoord1dv;
procedure _Init_glTexCoord1f;
procedure _Init_glTexCoord1fv;
procedure _Init_glTexCoord1i;
procedure _Init_glTexCoord1iv;
procedure _Init_glTexCoord1s;
procedure _Init_glTexCoord1sv;
procedure _Init_glTexCoord2d;
procedure _Init_glTexCoord2dv;
procedure _Init_glTexCoord2f;
procedure _Init_glTexCoord2fv;
procedure _Init_glTexCoord2i;
procedure _Init_glTexCoord2iv;
procedure _Init_glTexCoord2s;
procedure _Init_glTexCoord2sv;
procedure _Init_glTexCoord3d;
procedure _Init_glTexCoord3dv;
procedure _Init_glTexCoord3f;
procedure _Init_glTexCoord3fv;
procedure _Init_glTexCoord3i;
procedure _Init_glTexCoord3iv;
procedure _Init_glTexCoord3s;
procedure _Init_glTexCoord3sv;
procedure _Init_glTexCoord4d;
procedure _Init_glTexCoord4dv;
procedure _Init_glTexCoord4f;
procedure _Init_glTexCoord4fv;
procedure _Init_glTexCoord4i;
procedure _Init_glTexCoord4iv;
procedure _Init_glTexCoord4s;
procedure _Init_glTexCoord4sv;
procedure _Init_glTexCoordPointer;
procedure _Init_glTexEnvf;
procedure _Init_glTexEnvfv;
procedure _Init_glTexEnvi;
procedure _Init_glTexEnviv;
procedure _Init_glTexGend;
procedure _Init_glTexGendv;
procedure _Init_glTexGenf;
procedure _Init_glTexGenfv;
procedure _Init_glTexGeni;
procedure _Init_glTexGeniv;
procedure _Init_glTexImage1D;
procedure _Init_glTexImage2D;
procedure _Init_glTexParameterf;
procedure _Init_glTexParameterfv;
procedure _Init_glTexParameteri;
procedure _Init_glTexParameteriv;
procedure _Init_glTexSubImage1D;
procedure _Init_glTexSubImage2D;
procedure _Init_glTranslated;
procedure _Init_glTranslatef;
procedure _Init_glVertex2d;
procedure _Init_glVertex2dv;
procedure _Init_glVertex2f;
procedure _Init_glVertex2fv;
procedure _Init_glVertex2i;
procedure _Init_glVertex2iv;
procedure _Init_glVertex2s;
procedure _Init_glVertex2sv;
procedure _Init_glVertex3d;
procedure _Init_glVertex3dv;
procedure _Init_glVertex3f;
procedure _Init_glVertex3fv;
procedure _Init_glVertex3i;
procedure _Init_glVertex3iv;
procedure _Init_glVertex3s;
procedure _Init_glVertex3sv;
procedure _Init_glVertex4d;
procedure _Init_glVertex4dv;
procedure _Init_glVertex4f;
procedure _Init_glVertex4fv;
procedure _Init_glVertex4i;
procedure _Init_glVertex4iv;
procedure _Init_glVertex4s;
procedure _Init_glVertex4sv;
procedure _Init_glVertexPointer;
procedure _Init_glViewport;
    // window support routines
procedure _Init_wglGetProcAddress;
procedure _Init_wglCopyContext;
procedure _Init_wglCreateContext;
procedure _Init_wglCreateLayerContext;
procedure _Init_wglDeleteContext;
procedure _Init_wglDescribeLayerPlane;
procedure _Init_wglGetCurrentContext;
procedure _Init_wglGetCurrentDC;
procedure _Init_wglGetLayerPaletteEntries;
procedure _Init_wglMakeCurrent;
procedure _Init_wglRealizeLayerPalette;
procedure _Init_wglSetLayerPaletteEntries;
procedure _Init_wglShareLists;
procedure _Init_wglSwapLayerBuffers;
procedure _Init_wglSwapMultipleBuffers;
procedure _Init_wglUseFontBitmapsA;
procedure _Init_wglUseFontOutlinesA;
procedure _Init_wglUseFontBitmapsW;
procedure _Init_wglUseFontOutlinesW;
procedure _Init_wglUseFontBitmaps;
procedure _Init_wglUseFontOutlines;
    // GL 1.2
procedure _Init_glDrawRangeElements;
procedure _Init_glTexImage3D;
    // GL 1.2 ARB imaging
procedure _Init_glBlendColor;
procedure _Init_glBlendEquation;
procedure _Init_glColorSubTable;
procedure _Init_glCopyColorSubTable;
procedure _Init_glColorTable;
procedure _Init_glCopyColorTable;
procedure _Init_glColorTableParameteriv;
procedure _Init_glColorTableParameterfv;
procedure _Init_glGetColorTable;
procedure _Init_glGetColorTableParameteriv;
procedure _Init_glGetColorTableParameterfv;
procedure _Init_glConvolutionFilter1D;
procedure _Init_glConvolutionFilter2D;
procedure _Init_glCopyConvolutionFilter1D;
procedure _Init_glCopyConvolutionFilter2D;
procedure _Init_glGetConvolutionFilter;
procedure _Init_glSeparableFilter2D;
procedure _Init_glGetSeparableFilter;
procedure _Init_glConvolutionParameteri;
procedure _Init_glConvolutionParameteriv;
procedure _Init_glConvolutionParameterf;
procedure _Init_glConvolutionParameterfv;
procedure _Init_glGetConvolutionParameteriv;
procedure _Init_glGetConvolutionParameterfv;
procedure _Init_glHistogram;
procedure _Init_glResetHistogram;
procedure _Init_glGetHistogram;
procedure _Init_glGetHistogramParameteriv;
procedure _Init_glGetHistogramParameterfv;
procedure _Init_glMinmax;
procedure _Init_glResetMinmax;
procedure _Init_glGetMinmax;
procedure _Init_glGetMinmaxParameteriv;
procedure _Init_glGetMinmaxParameterfv;
//GLU
procedure _Init_gluBeginCurve;
procedure _Init_gluBeginPolygon;
procedure _Init_gluBeginSurface;
procedure _Init_gluBeginTrim;
procedure _Init_gluBuild1DMipmaps;
procedure _Init_gluBuild2DMipmaps;
procedure _Init_gluCylinder;
procedure _Init_gluDeleteNurbsRenderer;
procedure _Init_gluDeleteQuadric;
procedure _Init_gluDeleteTess;
procedure _Init_gluDisk;
procedure _Init_gluEndCurve;
procedure _Init_gluEndPolygon;
procedure _Init_gluEndSurface;
procedure _Init_gluEndTrim;
procedure _Init_gluErrorString;
procedure _Init_gluGetNurbsProperty;
procedure _Init_gluGetString;
procedure _Init_gluGetTessProperty;
procedure _Init_gluLoadSamplingMatrices;
procedure _Init_gluLookAt;
procedure _Init_gluNewNurbsRenderer;
procedure _Init_gluNewQuadric;
procedure _Init_gluNewTess;
procedure _Init_gluNextContour;
procedure _Init_gluNurbsCallback;
procedure _Init_gluNurbsCurve;
procedure _Init_gluNurbsProperty;
procedure _Init_gluNurbsSurface;
procedure _Init_gluOrtho2D;
procedure _Init_gluPartialDisk;
procedure _Init_gluPerspective;
procedure _Init_gluPickMatrix;
procedure _Init_gluProject;
procedure _Init_gluPwlCurve;
procedure _Init_gluQuadricCallback;
procedure _Init_gluQuadricDrawStyle;
procedure _Init_gluQuadricNormals;
procedure _Init_gluQuadricOrientation;
procedure _Init_gluQuadricTexture;
procedure _Init_gluScaleImage;
procedure _Init_gluSphere;
procedure _Init_gluTessBeginContour;
procedure _Init_gluTessBeginPolygon;
procedure _Init_gluTessCallback;
procedure _Init_gluTessEndContour;
procedure _Init_gluTessEndPolygon;
procedure _Init_gluTessNormal;
procedure _Init_gluTessProperty;
procedure _Init_gluTessVertex;
procedure _Init_gluUnProject;

{$J+}
const
  _glAccum_Addr:pointer = @_Init_glAccum;
  _glAlphaFunc_Addr:pointer = @_Init_glAlphaFunc;
  _glAreTexturesResident_Addr:pointer = @_Init_glAreTexturesResident;
  _glArrayElement_Addr:pointer = @_Init_glArrayElement;
  _glBegin_Addr:pointer = @_Init_glBegin;
  _glBindTexture_Addr: pointer = @_Init_glBindTexture;
  _glBitmap_Addr: pointer = @_Init_glBitmap;
  _glBlendFunc_Addr: pointer = @_Init_glBlendFunc;
  _glCallList_Addr: pointer = @_Init_glCallList;
  _glCallLists_Addr: pointer = @_Init_glCallLists;
  _glClear_Addr: pointer = @_Init_glClear;
  _glClearAccum_Addr: pointer = @_Init_glClearAccum;
  _glClearColor_Addr: pointer = @_Init_glClearColor;
  _glClearDepth_Addr: pointer = @_Init_glClearDepth;
  _glClearIndex_Addr: pointer = @_Init_glClearIndex;
  _glClearStencil_Addr: pointer = @_Init_glClearStencil;
  _glClipPlane_Addr: pointer = @_Init_glClipPlane;
  _glColor3b_Addr: pointer = @_Init_glColor3b;
  _glColor3bv_Addr: pointer = @_Init_glColor3bv;
  _glColor3d_Addr: pointer = @_Init_glColor3d;
  _glColor3dv_Addr: pointer = @_Init_glColor3dv;
  _glColor3f_Addr: pointer = @_Init_glColor3f;
  _glColor3fv_Addr: pointer = @_Init_glColor3fv;
  _glColor3i_Addr: pointer = @_Init_glColor3i;
  _glColor3iv_Addr: pointer = @_Init_glColor3iv;
  _glColor3s_Addr: pointer = @_Init_glColor3s;
  _glColor3sv_Addr: pointer = @_Init_glColor3sv;
  _glColor3ub_Addr: pointer = @_Init_glColor3ub;
  _glColor3ubv_Addr: pointer = @_Init_glColor3ubv;
  _glColor3ui_Addr: pointer = @_Init_glColor3ui;
  _glColor3uiv_Addr: pointer = @_Init_glColor3uiv;
  _glColor3us_Addr: pointer = @_Init_glColor3us;
  _glColor3usv_Addr: pointer = @_Init_glColor3usv;
  _glColor4b_Addr: pointer = @_Init_glColor4b;
  _glColor4bv_Addr: pointer = @_Init_glColor4bv;
  _glColor4d_Addr: pointer = @_Init_glColor4d;
  _glColor4dv_Addr: pointer = @_Init_glColor4dv;
  _glColor4f_Addr: pointer = @_Init_glColor4f;
  _glColor4fv_Addr: pointer = @_Init_glColor4fv;
  _glColor4i_Addr: pointer = @_Init_glColor4i;
  _glColor4iv_Addr: pointer = @_Init_glColor4iv;
  _glColor4s_Addr: pointer = @_Init_glColor4s;
  _glColor4sv_Addr: pointer = @_Init_glColor4sv;
  _glColor4ub_Addr: pointer = @_Init_glColor4ub;
  _glColor4ubv_Addr: pointer = @_Init_glColor4ubv;
  _glColor4ui_Addr: pointer = @_Init_glColor4ui;
  _glColor4uiv_Addr: pointer = @_Init_glColor4uiv;
  _glColor4us_Addr: pointer = @_Init_glColor4us;
  _glColor4usv_Addr: pointer = @_Init_glColor4usv;
  _glColorMask_Addr: pointer = @_Init_glColorMask;
  _glColorMaterial_Addr: pointer = @_Init_glColorMaterial;
  _glColorPointer_Addr: pointer = @_Init_glColorPointer;
  _glCopyPixels_Addr: pointer = @_Init_glCopyPixels;
  _glCopyTexImage1D_Addr: pointer = @_Init_glCopyTexImage1D;
  _glCopyTexImage2D_Addr: pointer = @_Init_glCopyTexImage2D;
  _glCopyTexSubImage1D_Addr: pointer = @_Init_glCopyTexSubImage1D;
  _glCopyTexSubImage2D_Addr: pointer = @_Init_glCopyTexSubImage2D;
  _glCullFace_Addr: pointer = @_Init_glCullFace;
  _glDeleteLists_Addr: pointer = @_Init_glDeleteLists;
  _glDeleteTextures_Addr: pointer = @_Init_glDeleteTextures;
  _glDepthFunc_Addr: pointer = @_Init_glDepthFunc;
  _glDepthMask_Addr: pointer = @_Init_glDepthMask;
  _glDepthRange_Addr: pointer = @_Init_glDepthRange;
  _glDisable_Addr: pointer = @_Init_glDisable;
  _glDisableClientState_Addr: pointer = @_Init_glDisableClientState;
  _glDrawArrays_Addr: pointer = @_Init_glDrawArrays;
  _glDrawBuffer_Addr: pointer = @_Init_glDrawBuffer;
  _glDrawElements_Addr: pointer = @_Init_glDrawElements;
  _glDrawPixels_Addr: pointer = @_Init_glDrawPixels;
  _glEdgeFlag_Addr: pointer = @_Init_glEdgeFlag;
  _glEdgeFlagPointer_Addr: pointer = @_Init_glEdgeFlagPointer;
  _glEdgeFlagv_Addr: pointer = @_Init_glEdgeFlagv;
  _glEnable_Addr: pointer = @_Init_glEnable;
  _glEnableClientState_Addr: pointer = @_Init_glEnableClientState;
  _glEnd_Addr: pointer = @_Init_glEnd;
  _glEndList_Addr: pointer = @_Init_glEndList;
  _glEvalCoord1d_Addr: pointer = @_Init_glEvalCoord1d;
  _glEvalCoord1dv_Addr: pointer = @_Init_glEvalCoord1dv;
  _glEvalCoord1f_Addr: pointer = @_Init_glEvalCoord1f;
  _glEvalCoord1fv_Addr: pointer = @_Init_glEvalCoord1fv;
  _glEvalCoord2d_Addr: pointer = @_Init_glEvalCoord2d;
  _glEvalCoord2dv_Addr: pointer = @_Init_glEvalCoord2dv;
  _glEvalCoord2f_Addr: pointer = @_Init_glEvalCoord2f;
  _glEvalCoord2fv_Addr: pointer = @_Init_glEvalCoord2fv;
  _glEvalMesh1_Addr: pointer = @_Init_glEvalMesh1;
  _glEvalMesh2_Addr: pointer = @_Init_glEvalMesh2;
  _glEvalPoint1_Addr: pointer = @_Init_glEvalPoint1;
  _glEvalPoint2_Addr: pointer = @_Init_glEvalPoint2;
  _glFeedbackBuffer_Addr: pointer = @_Init_glFeedbackBuffer;
  _glFinish_Addr: pointer = @_Init_glFinish;
  _glFlush_Addr: pointer = @_Init_glFlush;
  _glFogf_Addr: pointer = @_Init_glFogf;
  _glFogfv_Addr: pointer = @_Init_glFogfv;
  _glFogi_Addr: pointer = @_Init_glFogi;
  _glFogiv_Addr: pointer = @_Init_glFogiv;
  _glFrontFace_Addr: pointer = @_Init_glFrontFace;
  _glFrustum_Addr: pointer = @_Init_glFrustum;
  _glGenLists_Addr: pointer = @_Init_glGenLists;
  _glGenTextures_Addr: pointer = @_Init_glGenTextures;
  _glGetBooleanv_Addr: pointer = @_Init_glGetBooleanv;
  _glGetClipPlane_Addr: pointer = @_Init_glGetClipPlane;
  _glGetDoublev_Addr: pointer = @_Init_glGetDoublev;
  _glGetError_Addr: pointer = @_Init_glGetError;
  _glGetFloatv_Addr: pointer = @_Init_glGetFloatv;
  _glGetIntegerv_Addr: pointer = @_Init_glGetIntegerv;
  _glGetLightfv_Addr: pointer = @_Init_glGetLightfv;
  _glGetLightiv_Addr: pointer = @_Init_glGetLightiv;
  _glGetMapdv_Addr: pointer = @_Init_glGetMapdv;
  _glGetMapfv_Addr: pointer = @_Init_glGetMapfv;
  _glGetMapiv_Addr: pointer = @_Init_glGetMapiv;
  _glGetMaterialfv_Addr: pointer = @_Init_glGetMaterialfv;
  _glGetMaterialiv_Addr: pointer = @_Init_glGetMaterialiv;
  _glGetPixelMapfv_Addr: pointer = @_Init_glGetPixelMapfv;
  _glGetPixelMapuiv_Addr: pointer = @_Init_glGetPixelMapuiv;
  _glGetPixelMapusv_Addr: pointer = @_Init_glGetPixelMapusv;
  _glGetPointerv_Addr: pointer = @_Init_glGetPointerv;
  _glGetPolygonStipple_Addr: pointer = @_Init_glGetPolygonStipple;
  _glGetString_Addr: pointer = @_Init_glGetString;
  _glGetTexEnvfv_Addr: pointer = @_Init_glGetTexEnvfv;
  _glGetTexEnviv_Addr: pointer = @_Init_glGetTexEnviv;
  _glGetTexGendv_Addr: pointer = @_Init_glGetTexGendv;
  _glGetTexGenfv_Addr: pointer = @_Init_glGetTexGenfv;
  _glGetTexGeniv_Addr: pointer = @_Init_glGetTexGeniv;
  _glGetTexImage_Addr: pointer = @_Init_glGetTexImage;
  _glGetTexLevelParameterfv_Addr: pointer = @_Init_glGetTexLevelParameterfv;
  _glGetTexLevelParameteriv_Addr: pointer = @_Init_glGetTexLevelParameteriv;
  _glGetTexParameterfv_Addr: pointer = @_Init_glGetTexParameterfv;
  _glGetTexParameteriv_Addr: pointer = @_Init_glGetTexParameteriv;
  _glHint_Addr: pointer = @_Init_glHint;
  _glIndexMask_Addr: pointer = @_Init_glIndexMask;
  _glIndexPointer_Addr: pointer = @_Init_glIndexPointer;
  _glIndexd_Addr: pointer = @_Init_glIndexd;
  _glIndexdv_Addr: pointer = @_Init_glIndexdv;
  _glIndexf_Addr: pointer = @_Init_glIndexf;
  _glIndexfv_Addr: pointer = @_Init_glIndexfv;
  _glIndexi_Addr: pointer = @_Init_glIndexi;
  _glIndexiv_Addr: pointer = @_Init_glIndexiv;
  _glIndexs_Addr: pointer = @_Init_glIndexs;
  _glIndexsv_Addr: pointer = @_Init_glIndexsv;
  _glIndexub_Addr: pointer = @_Init_glIndexub;
  _glIndexubv_Addr: pointer = @_Init_glIndexubv;
  _glInitNames_Addr: pointer = @_Init_glInitNames;
  _glInterleavedArrays_Addr: pointer = @_Init_glInterleavedArrays;
  _glIsEnabled_Addr: pointer = @_Init_glIsEnabled;
  _glIsList_Addr: pointer = @_Init_glIsList;
  _glIsTexture_Addr: pointer = @_Init_glIsTexture;
  _glLightModelf_Addr: pointer = @_Init_glLightModelf;
  _glLightModelfv_Addr: pointer = @_Init_glLightModelfv;
  _glLightModeli_Addr: pointer = @_Init_glLightModeli;
  _glLightModeliv_Addr: pointer = @_Init_glLightModeliv;
  _glLightf_Addr: pointer = @_Init_glLightf;
  _glLightfv_Addr: pointer = @_Init_glLightfv;
  _glLighti_Addr: pointer = @_Init_glLighti;
  _glLightiv_Addr: pointer = @_Init_glLightiv;
  _glLineStipple_Addr: pointer = @_Init_glLineStipple;
  _glLineWidth_Addr: pointer = @_Init_glLineWidth;
  _glListBase_Addr: pointer = @_Init_glListBase;
  _glLoadIdentity_Addr: pointer = @_Init_glLoadIdentity;
  _glLoadMatrixd_Addr: pointer = @_Init_glLoadMatrixd;
  _glLoadMatrixf_Addr: pointer = @_Init_glLoadMatrixf;
  _glLoadName_Addr: pointer = @_Init_glLoadName;
  _glLogicOp_Addr: pointer = @_Init_glLogicOp;
  _glMap1d_Addr: pointer = @_Init_glMap1d;
  _glMap1f_Addr: pointer = @_Init_glMap1f;
  _glMap2d_Addr: pointer = @_Init_glMap2d;
  _glMap2f_Addr: pointer = @_Init_glMap2f;
  _glMapGrid1d_Addr: pointer = @_Init_glMapGrid1d;
  _glMapGrid1f_Addr: pointer = @_Init_glMapGrid1f;
  _glMapGrid2d_Addr: pointer = @_Init_glMapGrid2d;
  _glMapGrid2f_Addr: pointer = @_Init_glMapGrid2f;
  _glMaterialf_Addr: pointer = @_Init_glMaterialf;
  _glMaterialfv_Addr: pointer = @_Init_glMaterialfv;
  _glMateriali_Addr: pointer = @_Init_glMateriali;
  _glMaterialiv_Addr: pointer = @_Init_glMaterialiv;
  _glMatrixMode_Addr: pointer = @_Init_glMatrixMode;
  _glMultMatrixd_Addr: pointer = @_Init_glMultMatrixd;
  _glMultMatrixf_Addr: pointer = @_Init_glMultMatrixf;
  _glNewList_Addr: pointer = @_Init_glNewList;
  _glNormal3b_Addr: pointer = @_Init_glNormal3b;
  _glNormal3bv_Addr: pointer = @_Init_glNormal3bv;
  _glNormal3d_Addr: pointer = @_Init_glNormal3d;
  _glNormal3dv_Addr: pointer = @_Init_glNormal3dv;
  _glNormal3f_Addr: pointer = @_Init_glNormal3f;
  _glNormal3fv_Addr: pointer = @_Init_glNormal3fv;
  _glNormal3i_Addr: pointer = @_Init_glNormal3i;
  _glNormal3iv_Addr: pointer = @_Init_glNormal3iv;
  _glNormal3s_Addr: pointer = @_Init_glNormal3s;
  _glNormal3sv_Addr: pointer = @_Init_glNormal3sv;
  _glNormalPointer_Addr: pointer = @_Init_glNormalPointer;
  _glOrtho_Addr: pointer = @_Init_glOrtho;
  _glPassThrough_Addr: pointer = @_Init_glPassThrough;
  _glPixelMapfv_Addr: pointer = @_Init_glPixelMapfv;
  _glPixelMapuiv_Addr: pointer = @_Init_glPixelMapuiv;
  _glPixelMapusv_Addr: pointer = @_Init_glPixelMapusv;
  _glPixelStoref_Addr: pointer = @_Init_glPixelStoref;
  _glPixelStorei_Addr: pointer = @_Init_glPixelStorei;
  _glPixelTransferf_Addr: pointer = @_Init_glPixelTransferf;
  _glPixelTransferi_Addr: pointer = @_Init_glPixelTransferi;
  _glPixelZoom_Addr: pointer = @_Init_glPixelZoom;
  _glPointSize_Addr: pointer = @_Init_glPointSize;
  _glPolygonMode_Addr: pointer = @_Init_glPolygonMode;
  _glPolygonOffset_Addr: pointer = @_Init_glPolygonOffset;
  _glPolygonStipple_Addr: pointer = @_Init_glPolygonStipple;
  _glPopAttrib_Addr: pointer = @_Init_glPopAttrib;
  _glPopClientAttrib_Addr: pointer = @_Init_glPopClientAttrib;
  _glPopMatrix_Addr: pointer = @_Init_glPopMatrix;
  _glPopName_Addr: pointer = @_Init_glPopName;
  _glPrioritizeTextures_Addr: pointer = @_Init_glPrioritizeTextures;
  _glPushAttrib_Addr: pointer = @_Init_glPushAttrib;
  _glPushClientAttrib_Addr: pointer = @_Init_glPushClientAttrib;
  _glPushMatrix_Addr: pointer = @_Init_glPushMatrix;
  _glPushName_Addr: pointer = @_Init_glPushName;
  _glRasterPos2d_Addr: pointer = @_Init_glRasterPos2d;
  _glRasterPos2dv_Addr: pointer = @_Init_glRasterPos2dv;
  _glRasterPos2f_Addr: pointer = @_Init_glRasterPos2f;
  _glRasterPos2fv_Addr: pointer = @_Init_glRasterPos2fv;
  _glRasterPos2i_Addr: pointer = @_Init_glRasterPos2i;
  _glRasterPos2iv_Addr: pointer = @_Init_glRasterPos2iv;
  _glRasterPos2s_Addr: pointer = @_Init_glRasterPos2s;
  _glRasterPos2sv_Addr: pointer = @_Init_glRasterPos2sv;
  _glRasterPos3d_Addr: pointer = @_Init_glRasterPos3d;
  _glRasterPos3dv_Addr: pointer = @_Init_glRasterPos3dv;
  _glRasterPos3f_Addr: pointer = @_Init_glRasterPos3f;
  _glRasterPos3fv_Addr: pointer = @_Init_glRasterPos3fv;
  _glRasterPos3i_Addr: pointer = @_Init_glRasterPos3i;
  _glRasterPos3iv_Addr: pointer = @_Init_glRasterPos3iv;
  _glRasterPos3s_Addr: pointer = @_Init_glRasterPos3s;
  _glRasterPos3sv_Addr: pointer = @_Init_glRasterPos3sv;
  _glRasterPos4d_Addr: pointer = @_Init_glRasterPos4d;
  _glRasterPos4dv_Addr: pointer = @_Init_glRasterPos4dv;
  _glRasterPos4f_Addr: pointer = @_Init_glRasterPos4f;
  _glRasterPos4fv_Addr: pointer = @_Init_glRasterPos4fv;
  _glRasterPos4i_Addr: pointer = @_Init_glRasterPos4i;
  _glRasterPos4iv_Addr: pointer = @_Init_glRasterPos4iv;
  _glRasterPos4s_Addr: pointer = @_Init_glRasterPos4s;
  _glRasterPos4sv_Addr: pointer = @_Init_glRasterPos4sv;
  _glReadBuffer_Addr: pointer = @_Init_glReadBuffer;
  _glReadPixels_Addr: pointer = @_Init_glReadPixels;
  _glRectd_Addr: pointer = @_Init_glRectd;
  _glRectdv_Addr: pointer = @_Init_glRectdv;
  _glRectf_Addr: pointer = @_Init_glRectf;
  _glRectfv_Addr: pointer = @_Init_glRectfv;
  _glRecti_Addr: pointer = @_Init_glRecti;
  _glRectiv_Addr: pointer = @_Init_glRectiv;
  _glRects_Addr: pointer = @_Init_glRects;
  _glRectsv_Addr: pointer = @_Init_glRectsv;
  _glRenderMode_Addr: pointer = @_Init_glRenderMode;
  _glRotated_Addr: pointer = @_Init_glRotated;
  _glRotatef_Addr: pointer = @_Init_glRotatef;
  _glScaled_Addr: pointer = @_Init_glScaled;
  _glScalef_Addr: pointer = @_Init_glScalef;
  _glScissor_Addr: pointer = @_Init_glScissor;
  _glSelectBuffer_Addr: pointer = @_Init_glSelectBuffer;
  _glShadeModel_Addr: pointer = @_Init_glShadeModel;
  _glStencilFunc_Addr: pointer = @_Init_glStencilFunc;
  _glStencilMask_Addr: pointer = @_Init_glStencilMask;
  _glStencilOp_Addr: pointer = @_Init_glStencilOp;
  _glTexCoord1d_Addr: pointer = @_Init_glTexCoord1d;
  _glTexCoord1dv_Addr: pointer = @_Init_glTexCoord1dv;
  _glTexCoord1f_Addr: pointer = @_Init_glTexCoord1f;
  _glTexCoord1fv_Addr: pointer = @_Init_glTexCoord1fv;
  _glTexCoord1i_Addr: pointer = @_Init_glTexCoord1i;
  _glTexCoord1iv_Addr: pointer = @_Init_glTexCoord1iv;
  _glTexCoord1s_Addr: pointer = @_Init_glTexCoord1s;
  _glTexCoord1sv_Addr: pointer = @_Init_glTexCoord1sv;
  _glTexCoord2d_Addr: pointer = @_Init_glTexCoord2d;
  _glTexCoord2dv_Addr: pointer = @_Init_glTexCoord2dv;
  _glTexCoord2f_Addr: pointer = @_Init_glTexCoord2f;
  _glTexCoord2fv_Addr: pointer = @_Init_glTexCoord2fv;
  _glTexCoord2i_Addr: pointer = @_Init_glTexCoord2i;
  _glTexCoord2iv_Addr: pointer = @_Init_glTexCoord2iv;
  _glTexCoord2s_Addr: pointer = @_Init_glTexCoord2s;
  _glTexCoord2sv_Addr: pointer = @_Init_glTexCoord2sv;
  _glTexCoord3d_Addr: pointer = @_Init_glTexCoord3d;
  _glTexCoord3dv_Addr: pointer = @_Init_glTexCoord3dv;
  _glTexCoord3f_Addr: pointer = @_Init_glTexCoord3f;
  _glTexCoord3fv_Addr: pointer = @_Init_glTexCoord3fv;
  _glTexCoord3i_Addr: pointer = @_Init_glTexCoord3i;
  _glTexCoord3iv_Addr: pointer = @_Init_glTexCoord3iv;
  _glTexCoord3s_Addr: pointer = @_Init_glTexCoord3s;
  _glTexCoord3sv_Addr: pointer = @_Init_glTexCoord3sv;
  _glTexCoord4d_Addr: pointer = @_Init_glTexCoord4d;
  _glTexCoord4dv_Addr: pointer = @_Init_glTexCoord4dv;
  _glTexCoord4f_Addr: pointer = @_Init_glTexCoord4f;
  _glTexCoord4fv_Addr: pointer = @_Init_glTexCoord4fv;
  _glTexCoord4i_Addr: pointer = @_Init_glTexCoord4i;
  _glTexCoord4iv_Addr: pointer = @_Init_glTexCoord4iv;
  _glTexCoord4s_Addr: pointer = @_Init_glTexCoord4s;
  _glTexCoord4sv_Addr: pointer = @_Init_glTexCoord4sv;
  _glTexCoordPointer_Addr: pointer = @_Init_glTexCoordPointer;
  _glTexEnvf_Addr: pointer = @_Init_glTexEnvf;
  _glTexEnvfv_Addr: pointer = @_Init_glTexEnvfv;
  _glTexEnvi_Addr: pointer = @_Init_glTexEnvi;
  _glTexEnviv_Addr: pointer = @_Init_glTexEnviv;
  _glTexGend_Addr: pointer = @_Init_glTexGend;
  _glTexGendv_Addr: pointer = @_Init_glTexGendv;
  _glTexGenf_Addr: pointer = @_Init_glTexGenf;
  _glTexGenfv_Addr: pointer = @_Init_glTexGenfv;
  _glTexGeni_Addr: pointer = @_Init_glTexGeni;
  _glTexGeniv_Addr: pointer = @_Init_glTexGeniv;
  _glTexImage1D_Addr: pointer = @_Init_glTexImage1D;
  _glTexImage2D_Addr: pointer = @_Init_glTexImage2D;
  _glTexParameterf_Addr: pointer = @_Init_glTexParameterf;
  _glTexParameterfv_Addr: pointer = @_Init_glTexParameterfv;
  _glTexParameteri_Addr: pointer = @_Init_glTexParameteri;
  _glTexParameteriv_Addr: pointer = @_Init_glTexParameteriv;
  _glTexSubImage1D_Addr: pointer = @_Init_glTexSubImage1D;
  _glTexSubImage2D_Addr: pointer = @_Init_glTexSubImage2D;
  _glTranslated_Addr: pointer = @_Init_glTranslated;
  _glTranslatef_Addr: pointer = @_Init_glTranslatef;
  _glVertex2d_Addr: pointer = @_Init_glVertex2d;
  _glVertex2dv_Addr: pointer = @_Init_glVertex2dv;
  _glVertex2f_Addr: pointer = @_Init_glVertex2f;
  _glVertex2fv_Addr: pointer = @_Init_glVertex2fv;
  _glVertex2i_Addr: pointer = @_Init_glVertex2i;
  _glVertex2iv_Addr: pointer = @_Init_glVertex2iv;
  _glVertex2s_Addr: pointer = @_Init_glVertex2s;
  _glVertex2sv_Addr: pointer = @_Init_glVertex2sv;
  _glVertex3d_Addr: pointer = @_Init_glVertex3d;
  _glVertex3dv_Addr: pointer = @_Init_glVertex3dv;
  _glVertex3f_Addr: pointer = @_Init_glVertex3f;
  _glVertex3fv_Addr: pointer = @_Init_glVertex3fv;
  _glVertex3i_Addr: pointer = @_Init_glVertex3i;
  _glVertex3iv_Addr: pointer = @_Init_glVertex3iv;
  _glVertex3s_Addr: pointer = @_Init_glVertex3s;
  _glVertex3sv_Addr: pointer = @_Init_glVertex3sv;
  _glVertex4d_Addr: pointer = @_Init_glVertex4d;
  _glVertex4dv_Addr: pointer = @_Init_glVertex4dv;
  _glVertex4f_Addr: pointer = @_Init_glVertex4f;
  _glVertex4fv_Addr: pointer = @_Init_glVertex4fv;
  _glVertex4i_Addr: pointer = @_Init_glVertex4i;
  _glVertex4iv_Addr: pointer = @_Init_glVertex4iv;
  _glVertex4s_Addr: pointer = @_Init_glVertex4s;
  _glVertex4sv_Addr: pointer = @_Init_glVertex4sv;
  _glVertexPointer_Addr: pointer = @_Init_glVertexPointer;
  _glViewport_Addr: pointer = @_Init_glViewport;
  // window support functions
  _wglGetProcAddress_Addr: pointer = @_Init_wglGetProcAddress;
  _wglCopyContext_Addr: pointer = @_Init_wglCopyContext;
  _wglCreateContext_Addr: pointer = @_Init_wglCreateContext;
  _wglCreateLayerContext_Addr: pointer = @_Init_wglCreateLayerContext;
  _wglDeleteContext_Addr: pointer = @_Init_wglDeleteContext;
  _wglDescribeLayerPlane_Addr: pointer = @_Init_wglDescribeLayerPlane;
  _wglGetCurrentContext_Addr: pointer = @_Init_wglGetCurrentContext;
  _wglGetCurrentDC_Addr: pointer = @_Init_wglGetCurrentDC;
  _wglGetLayerPaletteEntries_Addr: pointer = @_Init_wglGetLayerPaletteEntries;
  _wglMakeCurrent_Addr: pointer = @_Init_wglMakeCurrent;
  _wglRealizeLayerPalette_Addr: pointer = @_Init_wglRealizeLayerPalette;
  _wglSetLayerPaletteEntries_Addr: pointer = @_Init_wglSetLayerPaletteEntries;
  _wglShareLists_Addr: pointer = @_Init_wglShareLists;
  _wglSwapLayerBuffers_Addr: pointer = @_Init_wglSwapLayerBuffers;
  _wglSwapMultipleBuffers_Addr: pointer = @_Init_wglSwapMultipleBuffers;
  _wglUseFontBitmapsA_Addr: pointer = @_Init_wglUseFontBitmapsA;
  _wglUseFontOutlinesA_Addr: pointer = @_Init_wglUseFontOutlinesA;
  _wglUseFontBitmapsW_Addr: pointer = @_Init_wglUseFontBitmapsW;
  _wglUseFontOutlinesW_Addr: pointer = @_Init_wglUseFontOutlinesW;
  _wglUseFontBitmaps_Addr: pointer = @_Init_wglUseFontBitmaps;
  _wglUseFontOutlines_Addr: pointer = @_Init_wglUseFontOutlines;
  // GL 1.2
  _glDrawRangeElements_Addr: pointer = @_Init_glDrawRangeElements;
  _glTexImage3D_Addr: pointer = @_Init_glTexImage3D;
  // GL 1.2 ARB imaging
  _glBlendColor_Addr: pointer = @_Init_glBlendColor;
  _glBlendEquation_Addr: pointer = @_Init_glBlendEquation;
  _glColorSubTable_Addr: pointer = @_Init_glColorSubTable;
  _glCopyColorSubTable_Addr: pointer = @_Init_glCopyColorSubTable;
  _glColorTable_Addr: pointer = @_Init_glColorTable;
  _glCopyColorTable_Addr: pointer = @_Init_glCopyColorTable;
  _glColorTableParameteriv_Addr: pointer = @_Init_glColorTableParameteriv;
  _glColorTableParameterfv_Addr: pointer = @_Init_glColorTableParameterfv;
  _glGetColorTable_Addr: pointer = @_Init_glGetColorTable;
  _glGetColorTableParameteriv_Addr: pointer = @_Init_glGetColorTableParameteriv;
  _glGetColorTableParameterfv_Addr: pointer = @_Init_glGetColorTableParameterfv;
  _glConvolutionFilter1D_Addr: pointer = @_Init_glConvolutionFilter1D;
  _glConvolutionFilter2D_Addr: pointer = @_Init_glConvolutionFilter2D;
  _glCopyConvolutionFilter1D_Addr: pointer = @_Init_glCopyConvolutionFilter1D;
  _glCopyConvolutionFilter2D_Addr: pointer = @_Init_glCopyConvolutionFilter2D;
  _glGetConvolutionFilter_Addr: pointer = @_Init_glGetConvolutionFilter;
  _glSeparableFilter2D_Addr: pointer = @_Init_glSeparableFilter2D;
  _glGetSeparableFilter_Addr: pointer = @_Init_glGetSeparableFilter;
  _glConvolutionParameteri_Addr: pointer = @_Init_glConvolutionParameteri;
  _glConvolutionParameteriv_Addr: pointer = @_Init_glConvolutionParameteriv;
  _glConvolutionParameterf_Addr: pointer = @_Init_glConvolutionParameterf;
  _glConvolutionParameterfv_Addr: pointer = @_Init_glConvolutionParameterfv;
  _glGetConvolutionParameteriv_Addr: pointer = @_Init_glGetConvolutionParameteriv;
  _glGetConvolutionParameterfv_Addr: pointer = @_Init_glGetConvolutionParameterfv;
  _glHistogram_Addr: pointer = @_Init_glHistogram;
  _glResetHistogram_Addr: pointer = @_Init_glResetHistogram;
  _glGetHistogram_Addr: pointer = @_Init_glGetHistogram;
  _glGetHistogramParameteriv_Addr: pointer = @_Init_glGetHistogramParameteriv;
  _glGetHistogramParameterfv_Addr: pointer = @_Init_glGetHistogramParameterfv;
  _glMinmax_Addr: pointer = @_Init_glMinmax;
  _glResetMinmax_Addr: pointer = @_Init_glResetMinmax;
  _glGetMinmax_Addr: pointer = @_Init_glGetMinmax;
  _glGetMinmaxParameteriv_Addr: pointer = @_Init_glGetMinmaxParameteriv;
  _glGetMinmaxParameterfv_Addr: pointer = @_Init_glGetMinmaxParameterfv;

  // GL utility functions and procedures
  _gluErrorString_Addr: pointer = @_Init_gluErrorString;
  _gluGetString_Addr: pointer = @_Init_gluGetString;
  _gluOrtho2D_Addr: pointer = @_Init_gluOrtho2D;
  _gluPerspective_Addr: pointer = @_Init_gluPerspective;
  _gluPickMatrix_Addr: pointer = @_Init_gluPickMatrix;
  _gluLookAt_Addr: pointer = @_Init_gluLookAt;
  _gluProject_Addr: pointer = @_Init_gluProject;
  _gluUnProject_Addr: pointer = @_Init_gluUnProject;
  _gluScaleImage_Addr: pointer = @_Init_gluScaleImage;
  _gluBuild1DMipmaps_Addr: pointer = @_Init_gluBuild1DMipmaps;
  _gluBuild2DMipmaps_Addr: pointer = @_Init_gluBuild2DMipmaps;
  _gluNewQuadric_Addr: pointer = @_Init_gluNewQuadric;
  _gluDeleteQuadric_Addr: pointer = @_Init_gluDeleteQuadric;
  _gluQuadricNormals_Addr: pointer = @_Init_gluQuadricNormals;
  _gluQuadricTexture_Addr: pointer = @_Init_gluQuadricTexture;
  _gluQuadricOrientation_Addr: pointer = @_Init_gluQuadricOrientation;
  _gluQuadricDrawStyle_Addr: pointer = @_Init_gluQuadricDrawStyle;
  _gluCylinder_Addr: pointer = @_Init_gluCylinder;
  _gluDisk_Addr: pointer = @_Init_gluDisk;
  _gluPartialDisk_Addr: pointer = @_Init_gluPartialDisk;
  _gluSphere_Addr: pointer = @_Init_gluSphere;
  _gluQuadricCallback_Addr: pointer = @_Init_gluQuadricCallback;
  _gluNewTess_Addr: pointer = @_Init_gluNewTess;
  _gluDeleteTess_Addr: pointer = @_Init_gluDeleteTess;
  _gluTessBeginPolygon_Addr: pointer = @_Init_gluTessBeginPolygon;
  _gluTessBeginContour_Addr: pointer = @_Init_gluTessBeginContour;
  _gluTessVertex_Addr: pointer = @_Init_gluTessVertex;
  _gluTessEndContour_Addr: pointer = @_Init_gluTessEndContour;
  _gluTessEndPolygon_Addr: pointer = @_Init_gluTessEndPolygon;
  _gluTessProperty_Addr: pointer = @_Init_gluTessProperty;
  _gluTessNormal_Addr: pointer = @_Init_gluTessNormal;
  _gluTessCallback_Addr: pointer = @_Init_gluTessCallback;
  _gluGetTessProperty_Addr: pointer = @_Init_gluGetTessProperty;
  _gluNewNurbsRenderer_Addr: pointer = @_Init_gluNewNurbsRenderer;
  _gluDeleteNurbsRenderer_Addr: pointer = @_Init_gluDeleteNurbsRenderer;
  _gluBeginSurface_Addr: pointer = @_Init_gluBeginSurface;
  _gluBeginCurve_Addr: pointer = @_Init_gluBeginCurve;
  _gluEndCurve_Addr: pointer = @_Init_gluEndCurve;
  _gluEndSurface_Addr: pointer = @_Init_gluEndSurface;
  _gluBeginTrim_Addr: pointer = @_Init_gluBeginTrim;
  _gluEndTrim_Addr: pointer = @_Init_gluEndTrim;
  _gluPwlCurve_Addr: pointer = @_Init_gluPwlCurve;
  _gluNurbsCurve_Addr: pointer = @_Init_gluNurbsCurve;
  _gluNurbsSurface_Addr: pointer = @_Init_gluNurbsSurface;
  _gluLoadSamplingMatrices_Addr: pointer = @_Init_gluLoadSamplingMatrices;
  _gluNurbsProperty_Addr: pointer = @_Init_gluNurbsProperty;
  _gluGetNurbsProperty_Addr: pointer = @_Init_gluGetNurbsProperty;
  _gluNurbsCallback_Addr: pointer = @_Init_gluNurbsCallback;
  _gluBeginPolygon_Addr: pointer = @_Init_gluBeginPolygon;
  _gluNextContour_Addr: pointer = @_Init_gluNextContour;
  _gluEndPolygon_Addr: pointer = @_Init_gluEndPolygon;

{$J-}

var
  // GL functions and procedures
  glAccum: _glAccum_ProcDeff absolute _glAccum_Addr;
  glAlphaFunc: _glAlphaFunc_ProcDeff absolute _glAlphaFunc_Addr;
  glAreTexturesResident: _glAreTexturesResident_ProcDeff absolute _glAreTexturesResident_Addr;
  glArrayElement: _glArrayElement_ProcDeff absolute _glArrayElement_Addr;
  glBegin: _glBegin_ProcDeff absolute _glBegin_Addr;
  glBindTexture: _glBindTexture_ProcDeff absolute _glBindTexture_Addr;
  glBitmap: _glBitmap_ProcDeff absolute _glBitmap_Addr;
  glBlendFunc: _glBlendFunc_ProcDeff absolute _glBlendFunc_Addr;
  glCallList: _glCallList_ProcDeff absolute _glCallList_Addr;
  glCallLists: _glCallLists_ProcDeff absolute _glCallLists_Addr;
  glClear: _glClear_ProcDeff absolute _glClear_Addr;
  glClearAccum: _glClearAccum_ProcDeff absolute _glClearAccum_Addr;
  glClearColor: _glClearColor_ProcDeff absolute _glClearColor_Addr;
  glClearDepth: _glClearDepth_ProcDeff absolute _glClearDepth_Addr;
  glClearIndex: _glClearIndex_ProcDeff absolute _glClearIndex_Addr;
  glClearStencil: _glClearStencil_ProcDeff absolute _glClearStencil_Addr;
  glClipPlane: _glClipPlane_ProcDeff absolute _glClipPlane_Addr;
  glColor3b: _glColor3b_ProcDeff absolute _glColor3b_Addr;
  glColor3bv: _glColor3bv_ProcDeff absolute _glColor3bv_Addr;
  glColor3d: _glColor3d_ProcDeff absolute _glColor3d_Addr;
  glColor3dv: _glColor3dv_ProcDeff absolute _glColor3dv_Addr;
  glColor3f: _glColor3f_ProcDeff absolute _glColor3f_Addr;
  glColor3fv: _glColor3fv_ProcDeff absolute _glColor3fv_Addr;
  glColor3i: _glColor3i_ProcDeff absolute _glColor3i_Addr;
  glColor3iv: _glColor3iv_ProcDeff absolute _glColor3iv_Addr;
  glColor3s: _glColor3s_ProcDeff absolute _glColor3s_Addr;
  glColor3sv: _glColor3sv_ProcDeff absolute _glColor3sv_Addr;
  glColor3ub: _glColor3ub_ProcDeff absolute _glColor3ub_Addr;
  glColor3ubv: _glColor3ubv_ProcDeff absolute _glColor3ubv_Addr;
  glColor3ui: _glColor3ui_ProcDeff absolute _glColor3ui_Addr;
  glColor3uiv: _glColor3uiv_ProcDeff absolute _glColor3uiv_Addr;
  glColor3us: _glColor3us_ProcDeff absolute _glColor3us_Addr;
  glColor3usv: _glColor3usv_ProcDeff absolute _glColor3usv_Addr;
  glColor4b: _glColor4b_ProcDeff absolute _glColor4b_Addr;
  glColor4bv: _glColor4bv_ProcDeff absolute _glColor4bv_Addr;
  glColor4d: _glColor4d_ProcDeff absolute _glColor4d_Addr;
  glColor4dv: _glColor4dv_ProcDeff absolute _glColor4dv_Addr;
  glColor4f: _glColor4f_ProcDeff absolute _glColor4f_Addr;
  glColor4fv: _glColor4fv_ProcDeff absolute _glColor4fv_Addr;
  glColor4i: _glColor4i_ProcDeff absolute _glColor4i_Addr;
  glColor4iv: _glColor4iv_ProcDeff absolute _glColor4iv_Addr;
  glColor4s: _glColor4s_ProcDeff absolute _glColor4s_Addr;
  glColor4sv: _glColor4sv_ProcDeff absolute _glColor4sv_Addr;
  glColor4ub: _glColor4ub_ProcDeff absolute _glColor4ub_Addr;
  glColor4ubv: _glColor4ubv_ProcDeff absolute _glColor4ubv_Addr;
  glColor4ui: _glColor4ui_ProcDeff absolute _glColor4ui_Addr;
  glColor4uiv: _glColor4uiv_ProcDeff absolute _glColor4uiv_Addr;
  glColor4us: _glColor4us_ProcDeff absolute _glColor4us_Addr;
  glColor4usv: _glColor4usv_ProcDeff absolute _glColor4usv_Addr;
  glColorMask: _glColorMask_ProcDeff absolute _glColorMask_Addr;
  glColorMaterial: _glColorMaterial_ProcDeff absolute _glColorMaterial_Addr;
  glColorPointer: _glColorPointer_ProcDeff absolute _glColorPointer_Addr;
  glCopyPixels: _glCopyPixels_ProcDeff absolute _glCopyPixels_Addr;
  glCopyTexImage1D: _glCopyTexImage1D_ProcDeff absolute _glCopyTexImage1D_Addr;
  glCopyTexImage2D: _glCopyTexImage2D_ProcDeff absolute _glCopyTexImage2D_Addr;
  glCopyTexSubImage1D: _glCopyTexSubImage1D_ProcDeff absolute _glCopyTexSubImage1D_Addr;
  glCopyTexSubImage2D: _glCopyTexSubImage2D_ProcDeff absolute _glCopyTexSubImage2D_Addr;
  glCullFace: _glCullFace_ProcDeff absolute _glCullFace_Addr;
  glDeleteLists: _glDeleteLists_ProcDeff absolute _glDeleteLists_Addr;
  glDeleteTextures: _glDeleteTextures_ProcDeff absolute _glDeleteTextures_Addr;
  glDepthFunc: _glDepthFunc_ProcDeff absolute _glDepthFunc_Addr;
  glDepthMask: _glDepthMask_ProcDeff absolute _glDepthMask_Addr;
  glDepthRange: _glDepthRange_ProcDeff absolute _glDepthRange_Addr;
  glDisable: _glDisable_ProcDeff absolute _glDisable_Addr;
  glDisableClientState: _glDisableClientState_ProcDeff absolute _glDisableClientState_Addr;
  glDrawArrays: _glDrawArrays_ProcDeff absolute _glDrawArrays_Addr;
  glDrawBuffer: _glDrawBuffer_ProcDeff absolute _glDrawBuffer_Addr;
  glDrawElements: _glDrawElements_ProcDeff absolute _glDrawElements_Addr;
  glDrawPixels: _glDrawPixels_ProcDeff absolute _glDrawPixels_Addr;
  glEdgeFlag: _glEdgeFlag_ProcDeff absolute _glEdgeFlag_Addr;
  glEdgeFlagPointer: _glEdgeFlagPointer_ProcDeff absolute _glEdgeFlagPointer_Addr;
  glEdgeFlagv: _glEdgeFlagv_ProcDeff absolute _glEdgeFlagv_Addr;
  glEnable: _glEnable_ProcDeff absolute _glEnable_Addr;
  glEnableClientState: _glEnableClientState_ProcDeff absolute _glEnableClientState_Addr;
  glEnd: _glEnd_ProcDeff absolute _glEnd_Addr;
  glEndList: _glEndList_ProcDeff absolute _glEndList_Addr;
  glEvalCoord1d: _glEvalCoord1d_ProcDeff absolute _glEvalCoord1d_Addr;
  glEvalCoord1dv: _glEvalCoord1dv_ProcDeff absolute _glEvalCoord1dv_Addr;
  glEvalCoord1f: _glEvalCoord1f_ProcDeff absolute _glEvalCoord1f_Addr;
  glEvalCoord1fv: _glEvalCoord1fv_ProcDeff absolute _glEvalCoord1fv_Addr;
  glEvalCoord2d: _glEvalCoord2d_ProcDeff absolute _glEvalCoord2d_Addr;
  glEvalCoord2dv: _glEvalCoord2dv_ProcDeff absolute _glEvalCoord2dv_Addr;
  glEvalCoord2f: _glEvalCoord2f_ProcDeff absolute _glEvalCoord2f_Addr;
  glEvalCoord2fv: _glEvalCoord2fv_ProcDeff absolute _glEvalCoord2fv_Addr;
  glEvalMesh1: _glEvalMesh1_ProcDeff absolute _glEvalMesh1_Addr;
  glEvalMesh2: _glEvalMesh2_ProcDeff absolute _glEvalMesh2_Addr;
  glEvalPoint1: _glEvalPoint1_ProcDeff absolute _glEvalPoint1_Addr;
  glEvalPoint2: _glEvalPoint2_ProcDeff absolute _glEvalPoint2_Addr;
  glFeedbackBuffer: _glFeedbackBuffer_ProcDeff absolute _glFeedbackBuffer_Addr;
  glFinish: _glFinish_ProcDeff absolute _glFinish_Addr;
  glFlush: _glFlush_ProcDeff absolute _glFlush_Addr;
  glFogf: _glFogf_ProcDeff absolute _glFogf_Addr;
  glFogfv: _glFogfv_ProcDeff absolute _glFogfv_Addr;
  glFogi: _glFogi_ProcDeff absolute _glFogi_Addr;
  glFogiv: _glFogiv_ProcDeff absolute _glFogiv_Addr;
  glFrontFace: _glFrontFace_ProcDeff absolute _glFrontFace_Addr;
  glFrustum: _glFrustum_ProcDeff absolute _glFrustum_Addr;
  glGenLists: _glGenLists_ProcDeff absolute _glGenLists_Addr;
  glGenTextures: _glGenTextures_ProcDeff absolute _glGenTextures_Addr;
  glGetBooleanv: _glGetBooleanv_ProcDeff absolute _glGetBooleanv_Addr;
  glGetClipPlane: _glGetClipPlane_ProcDeff absolute _glGetClipPlane_Addr;
  glGetDoublev: _glGetDoublev_ProcDeff absolute _glGetDoublev_Addr;
  glGetError: _glGetError_ProcDeff absolute _glGetError_Addr;
  glGetFloatv: _glGetFloatv_ProcDeff absolute _glGetFloatv_Addr;
  glGetIntegerv: _glGetIntegerv_ProcDeff absolute _glGetIntegerv_Addr;
  glGetLightfv: _glGetLightfv_ProcDeff absolute _glGetLightfv_Addr;
  glGetLightiv: _glGetLightiv_ProcDeff absolute _glGetLightiv_Addr;
  glGetMapdv: _glGetMapdv_ProcDeff absolute _glGetMapdv_Addr;
  glGetMapfv: _glGetMapfv_ProcDeff absolute _glGetMapfv_Addr;
  glGetMapiv: _glGetMapiv_ProcDeff absolute _glGetMapiv_Addr;
  glGetMaterialfv: _glGetMaterialfv_ProcDeff absolute _glGetMaterialfv_Addr;
  glGetMaterialiv: _glGetMaterialiv_ProcDeff absolute _glGetMaterialiv_Addr;
  glGetPixelMapfv: _glGetPixelMapfv_ProcDeff absolute _glGetPixelMapfv_Addr;
  glGetPixelMapuiv: _glGetPixelMapuiv_ProcDeff absolute _glGetPixelMapuiv_Addr;
  glGetPixelMapusv: _glGetPixelMapusv_ProcDeff absolute _glGetPixelMapusv_Addr;
  glGetPointerv: _glGetPointerv_ProcDeff absolute _glGetPointerv_Addr;
  glGetPolygonStipple: _glGetPolygonStipple_ProcDeff absolute _glGetPolygonStipple_Addr;
  glGetString: _glGetString_ProcDeff absolute _glGetString_Addr;
  glGetTexEnvfv: _glGetTexEnvfv_ProcDeff absolute _glGetTexEnvfv_Addr;
  glGetTexEnviv: _glGetTexEnviv_ProcDeff absolute _glGetTexEnviv_Addr;
  glGetTexGendv: _glGetTexGendv_ProcDeff absolute _glGetTexGendv_Addr;
  glGetTexGenfv: _glGetTexGenfv_ProcDeff absolute _glGetTexGenfv_Addr;
  glGetTexGeniv: _glGetTexGeniv_ProcDeff absolute _glGetTexGeniv_Addr;
  glGetTexImage: _glGetTexImage_ProcDeff absolute _glGetTexImage_Addr;
  glGetTexLevelParameterfv: _glGetTexLevelParameterfv_ProcDeff absolute _glGetTexLevelParameterfv_Addr;
  glGetTexLevelParameteriv: _glGetTexLevelParameteriv_ProcDeff absolute _glGetTexLevelParameteriv_Addr;
  glGetTexParameterfv: _glGetTexParameterfv_ProcDeff absolute _glGetTexParameterfv_Addr;
  glGetTexParameteriv: _glGetTexParameteriv_ProcDeff absolute _glGetTexParameteriv_Addr;
  glHint: _glHint_ProcDeff absolute _glHint_Addr;
  glIndexMask: _glIndexMask_ProcDeff absolute _glIndexMask_Addr;
  glIndexPointer: _glIndexPointer_ProcDeff absolute _glIndexPointer_Addr;
  glIndexd: _glIndexd_ProcDeff absolute _glIndexd_Addr;
  glIndexdv: _glIndexdv_ProcDeff absolute _glIndexdv_Addr;
  glIndexf: _glIndexf_ProcDeff absolute _glIndexf_Addr;
  glIndexfv: _glIndexfv_ProcDeff absolute _glIndexfv_Addr;
  glIndexi: _glIndexi_ProcDeff absolute _glIndexi_Addr;
  glIndexiv: _glIndexiv_ProcDeff absolute _glIndexiv_Addr;
  glIndexs: _glIndexs_ProcDeff absolute _glIndexs_Addr;
  glIndexsv: _glIndexsv_ProcDeff absolute _glIndexsv_Addr;
  glIndexub: _glIndexub_ProcDeff absolute _glIndexub_Addr;
  glIndexubv: _glIndexubv_ProcDeff absolute _glIndexubv_Addr;
  glInitNames: _glInitNames_ProcDeff absolute _glInitNames_Addr;
  glInterleavedArrays: _glInterleavedArrays_ProcDeff absolute _glInterleavedArrays_Addr;
  glIsEnabled: _glIsEnabled_ProcDeff absolute _glIsEnabled_Addr;
  glIsList: _glIsList_ProcDeff absolute _glIsList_Addr;
  glIsTexture: _glIsTexture_ProcDeff absolute _glIsTexture_Addr;
  glLightModelf: _glLightModelf_ProcDeff absolute _glLightModelf_Addr;
  glLightModelfv: _glLightModelfv_ProcDeff absolute _glLightModelfv_Addr;
  glLightModeli: _glLightModeli_ProcDeff absolute _glLightModeli_Addr;
  glLightModeliv: _glLightModeliv_ProcDeff absolute _glLightModeliv_Addr;
  glLightf: _glLightf_ProcDeff absolute _glLightf_Addr;
  glLightfv: _glLightfv_ProcDeff absolute _glLightfv_Addr;
  glLighti: _glLighti_ProcDeff absolute _glLighti_Addr;
  glLightiv: _glLightiv_ProcDeff absolute _glLightiv_Addr;
  glLineStipple: _glLineStipple_ProcDeff absolute _glLineStipple_Addr;
  glLineWidth: _glLineWidth_ProcDeff absolute _glLineWidth_Addr;
  glListBase: _glListBase_ProcDeff absolute _glListBase_Addr;
  glLoadIdentity: _glLoadIdentity_ProcDeff absolute _glLoadIdentity_Addr;
  glLoadMatrixd: _glLoadMatrixd_ProcDeff absolute _glLoadMatrixd_Addr;
  glLoadMatrixf: _glLoadMatrixf_ProcDeff absolute _glLoadMatrixf_Addr;
  glLoadName: _glLoadName_ProcDeff absolute _glLoadName_Addr;
  glLogicOp: _glLogicOp_ProcDeff absolute _glLogicOp_Addr;
  glMap1d: _glMap1d_ProcDeff absolute _glMap1d_Addr;
  glMap1f: _glMap1f_ProcDeff absolute _glMap1f_Addr;
  glMap2d: _glMap2d_ProcDeff absolute _glMap2d_Addr;
  glMap2f: _glMap2f_ProcDeff absolute _glMap2f_Addr;
  glMapGrid1d: _glMapGrid1d_ProcDeff absolute _glMapGrid1d_Addr;
  glMapGrid1f: _glMapGrid1f_ProcDeff absolute _glMapGrid1f_Addr;
  glMapGrid2d: _glMapGrid2d_ProcDeff absolute _glMapGrid2d_Addr;
  glMapGrid2f: _glMapGrid2f_ProcDeff absolute _glMapGrid2f_Addr;
  glMaterialf: _glMaterialf_ProcDeff absolute _glMaterialf_Addr;
  glMaterialfv: _glMaterialfv_ProcDeff absolute _glMaterialfv_Addr;
  glMateriali: _glMateriali_ProcDeff absolute _glMateriali_Addr;
  glMaterialiv: _glMaterialiv_ProcDeff absolute _glMaterialiv_Addr;
  glMatrixMode: _glMatrixMode_ProcDeff absolute _glMatrixMode_Addr;
  glMultMatrixd: _glMultMatrixd_ProcDeff absolute _glMultMatrixd_Addr;
  glMultMatrixf: _glMultMatrixf_ProcDeff absolute _glMultMatrixf_Addr;
  glNewList: _glNewList_ProcDeff absolute _glNewList_Addr;
  glNormal3b: _glNormal3b_ProcDeff absolute _glNormal3b_Addr;
  glNormal3bv: _glNormal3bv_ProcDeff absolute _glNormal3bv_Addr;
  glNormal3d: _glNormal3d_ProcDeff absolute _glNormal3d_Addr;
  glNormal3dv: _glNormal3dv_ProcDeff absolute _glNormal3dv_Addr;
  glNormal3f: _glNormal3f_ProcDeff absolute _glNormal3f_Addr;
  glNormal3fv: _glNormal3fv_ProcDeff absolute _glNormal3fv_Addr;
  glNormal3i: _glNormal3i_ProcDeff absolute _glNormal3i_Addr;
  glNormal3iv: _glNormal3iv_ProcDeff absolute _glNormal3iv_Addr;
  glNormal3s: _glNormal3s_ProcDeff absolute _glNormal3s_Addr;
  glNormal3sv: _glNormal3sv_ProcDeff absolute _glNormal3sv_Addr;
  glNormalPointer: _glNormalPointer_ProcDeff absolute _glNormalPointer_Addr;
  glOrtho: _glOrtho_ProcDeff absolute _glOrtho_Addr;
  glPassThrough: _glPassThrough_ProcDeff absolute _glPassThrough_Addr;
  glPixelMapfv: _glPixelMapfv_ProcDeff absolute _glPixelMapfv_Addr;
  glPixelMapuiv: _glPixelMapuiv_ProcDeff absolute _glPixelMapuiv_Addr;
  glPixelMapusv: _glPixelMapusv_ProcDeff absolute _glPixelMapusv_Addr;
  glPixelStoref: _glPixelStoref_ProcDeff absolute _glPixelStoref_Addr;
  glPixelStorei: _glPixelStorei_ProcDeff absolute _glPixelStorei_Addr;
  glPixelTransferf: _glPixelTransferf_ProcDeff absolute _glPixelTransferf_Addr;
  glPixelTransferi: _glPixelTransferi_ProcDeff absolute _glPixelTransferi_Addr;
  glPixelZoom: _glPixelZoom_ProcDeff absolute _glPixelZoom_Addr;
  glPointSize: _glPointSize_ProcDeff absolute _glPointSize_Addr;
  glPolygonMode: _glPolygonMode_ProcDeff absolute _glPolygonMode_Addr;
  glPolygonOffset: _glPolygonOffset_ProcDeff absolute _glPolygonOffset_Addr;
  glPolygonStipple: _glPolygonStipple_ProcDeff absolute _glPolygonStipple_Addr;
  glPopAttrib: _glPopAttrib_ProcDeff absolute _glPopAttrib_Addr;
  glPopClientAttrib: _glPopClientAttrib_ProcDeff absolute _glPopClientAttrib_Addr;
  glPopMatrix: _glPopMatrix_ProcDeff absolute _glPopMatrix_Addr;
  glPopName: _glPopName_ProcDeff absolute _glPopName_Addr;
  glPrioritizeTextures: _glPrioritizeTextures_ProcDeff absolute _glPrioritizeTextures_Addr;
  glPushAttrib: _glPushAttrib_ProcDeff absolute _glPushAttrib_Addr;
  glPushClientAttrib: _glPushClientAttrib_ProcDeff absolute _glPushClientAttrib_Addr;
  glPushMatrix: _glPushMatrix_ProcDeff absolute _glPushMatrix_Addr;
  glPushName: _glPushName_ProcDeff absolute _glPushName_Addr;
  glRasterPos2d: _glRasterPos2d_ProcDeff absolute _glRasterPos2d_Addr;
  glRasterPos2dv: _glRasterPos2dv_ProcDeff absolute _glRasterPos2dv_Addr;
  glRasterPos2f: _glRasterPos2f_ProcDeff absolute _glRasterPos2f_Addr;
  glRasterPos2fv: _glRasterPos2fv_ProcDeff absolute _glRasterPos2fv_Addr;
  glRasterPos2i: _glRasterPos2i_ProcDeff absolute _glRasterPos2i_Addr;
  glRasterPos2iv: _glRasterPos2iv_ProcDeff absolute _glRasterPos2iv_Addr;
  glRasterPos2s: _glRasterPos2s_ProcDeff absolute _glRasterPos2s_Addr;
  glRasterPos2sv: _glRasterPos2sv_ProcDeff absolute _glRasterPos2sv_Addr;
  glRasterPos3d: _glRasterPos3d_ProcDeff absolute _glRasterPos3d_Addr;
  glRasterPos3dv: _glRasterPos3dv_ProcDeff absolute _glRasterPos3dv_Addr;
  glRasterPos3f: _glRasterPos3f_ProcDeff absolute _glRasterPos3f_Addr;
  glRasterPos3fv: _glRasterPos3fv_ProcDeff absolute _glRasterPos3fv_Addr;
  glRasterPos3i: _glRasterPos3i_ProcDeff absolute _glRasterPos3i_Addr;
  glRasterPos3iv: _glRasterPos3iv_ProcDeff absolute _glRasterPos3iv_Addr;
  glRasterPos3s: _glRasterPos3s_ProcDeff absolute _glRasterPos3s_Addr;
  glRasterPos3sv: _glRasterPos3sv_ProcDeff absolute _glRasterPos3sv_Addr;
  glRasterPos4d: _glRasterPos4d_ProcDeff absolute _glRasterPos4d_Addr;
  glRasterPos4dv: _glRasterPos4dv_ProcDeff absolute _glRasterPos4dv_Addr;
  glRasterPos4f: _glRasterPos4f_ProcDeff absolute _glRasterPos4f_Addr;
  glRasterPos4fv: _glRasterPos4fv_ProcDeff absolute _glRasterPos4fv_Addr;
  glRasterPos4i: _glRasterPos4i_ProcDeff absolute _glRasterPos4i_Addr;
  glRasterPos4iv: _glRasterPos4iv_ProcDeff absolute _glRasterPos4iv_Addr;
  glRasterPos4s: _glRasterPos4s_ProcDeff absolute _glRasterPos4s_Addr;
  glRasterPos4sv: _glRasterPos4sv_ProcDeff absolute _glRasterPos4sv_Addr;
  glReadBuffer: _glReadBuffer_ProcDeff absolute _glReadBuffer_Addr;
  glReadPixels: _glReadPixels_ProcDeff absolute _glReadPixels_Addr;
  glRectd: _glRectd_ProcDeff absolute _glRectd_Addr;
  glRectdv: _glRectdv_ProcDeff absolute _glRectdv_Addr;
  glRectf: _glRectf_ProcDeff absolute _glRectf_Addr;
  glRectfv: _glRectfv_ProcDeff absolute _glRectfv_Addr;
  glRecti: _glRecti_ProcDeff absolute _glRecti_Addr;
  glRectiv: _glRectiv_ProcDeff absolute _glRectiv_Addr;
  glRects: _glRects_ProcDeff absolute _glRects_Addr;
  glRectsv: _glRectsv_ProcDeff absolute _glRectsv_Addr;
  glRenderMode: _glRenderMode_ProcDeff absolute _glRenderMode_Addr;
  glRotated: _glRotated_ProcDeff absolute _glRotated_Addr;
  glRotatef: _glRotatef_ProcDeff absolute _glRotatef_Addr;
  glScaled: _glScaled_ProcDeff absolute _glScaled_Addr;
  glScalef: _glScalef_ProcDeff absolute _glScalef_Addr;
  glScissor: _glScissor_ProcDeff absolute _glScissor_Addr;
  glSelectBuffer: _glSelectBuffer_ProcDeff absolute _glSelectBuffer_Addr;
  glShadeModel: _glShadeModel_ProcDeff absolute _glShadeModel_Addr;
  glStencilFunc: _glStencilFunc_ProcDeff absolute _glStencilFunc_Addr;
  glStencilMask: _glStencilMask_ProcDeff absolute _glStencilMask_Addr;
  glStencilOp: _glStencilOp_ProcDeff absolute _glStencilOp_Addr;
  glTexCoord1d: _glTexCoord1d_ProcDeff absolute _glTexCoord1d_Addr;
  glTexCoord1dv: _glTexCoord1dv_ProcDeff absolute _glTexCoord1dv_Addr;
  glTexCoord1f: _glTexCoord1f_ProcDeff absolute _glTexCoord1f_Addr;
  glTexCoord1fv: _glTexCoord1fv_ProcDeff absolute _glTexCoord1fv_Addr;
  glTexCoord1i: _glTexCoord1i_ProcDeff absolute _glTexCoord1i_Addr;
  glTexCoord1iv: _glTexCoord1iv_ProcDeff absolute _glTexCoord1iv_Addr;
  glTexCoord1s: _glTexCoord1s_ProcDeff absolute _glTexCoord1s_Addr;
  glTexCoord1sv: _glTexCoord1sv_ProcDeff absolute _glTexCoord1sv_Addr;
  glTexCoord2d: _glTexCoord2d_ProcDeff absolute _glTexCoord2d_Addr;
  glTexCoord2dv: _glTexCoord2dv_ProcDeff absolute _glTexCoord2dv_Addr;
  glTexCoord2f: _glTexCoord2f_ProcDeff absolute _glTexCoord2f_Addr;
  glTexCoord2fv: _glTexCoord2fv_ProcDeff absolute _glTexCoord2fv_Addr;
  glTexCoord2i: _glTexCoord2i_ProcDeff absolute _glTexCoord2i_Addr;
  glTexCoord2iv: _glTexCoord2iv_ProcDeff absolute _glTexCoord2iv_Addr;
  glTexCoord2s: _glTexCoord2s_ProcDeff absolute _glTexCoord2s_Addr;
  glTexCoord2sv: _glTexCoord2sv_ProcDeff absolute _glTexCoord2sv_Addr;
  glTexCoord3d: _glTexCoord3d_ProcDeff absolute _glTexCoord3d_Addr;
  glTexCoord3dv: _glTexCoord3dv_ProcDeff absolute _glTexCoord3dv_Addr;
  glTexCoord3f: _glTexCoord3f_ProcDeff absolute _glTexCoord3f_Addr;
  glTexCoord3fv: _glTexCoord3fv_ProcDeff absolute _glTexCoord3fv_Addr;
  glTexCoord3i: _glTexCoord3i_ProcDeff absolute _glTexCoord3i_Addr;
  glTexCoord3iv: _glTexCoord3iv_ProcDeff absolute _glTexCoord3iv_Addr;
  glTexCoord3s: _glTexCoord3s_ProcDeff absolute _glTexCoord3s_Addr;
  glTexCoord3sv: _glTexCoord3sv_ProcDeff absolute _glTexCoord3sv_Addr;
  glTexCoord4d: _glTexCoord4d_ProcDeff absolute _glTexCoord4d_Addr;
  glTexCoord4dv: _glTexCoord4dv_ProcDeff absolute _glTexCoord4dv_Addr;
  glTexCoord4f: _glTexCoord4f_ProcDeff absolute _glTexCoord4f_Addr;
  glTexCoord4fv: _glTexCoord4fv_ProcDeff absolute _glTexCoord4fv_Addr;
  glTexCoord4i: _glTexCoord4i_ProcDeff absolute _glTexCoord4i_Addr;
  glTexCoord4iv: _glTexCoord4iv_ProcDeff absolute _glTexCoord4iv_Addr;
  glTexCoord4s: _glTexCoord4s_ProcDeff absolute _glTexCoord4s_Addr;
  glTexCoord4sv: _glTexCoord4sv_ProcDeff absolute _glTexCoord4sv_Addr;
  glTexCoordPointer: _glTexCoordPointer_ProcDeff absolute _glTexCoordPointer_Addr;
  glTexEnvf: _glTexEnvf_ProcDeff absolute _glTexEnvf_Addr;
  glTexEnvfv: _glTexEnvfv_ProcDeff absolute _glTexEnvfv_Addr;
  glTexEnvi: _glTexEnvi_ProcDeff absolute _glTexEnvi_Addr;
  glTexEnviv: _glTexEnviv_ProcDeff absolute _glTexEnviv_Addr;
  glTexGend: _glTexGend_ProcDeff absolute _glTexGend_Addr;
  glTexGendv: _glTexGendv_ProcDeff absolute _glTexGendv_Addr;
  glTexGenf: _glTexGenf_ProcDeff absolute _glTexGenf_Addr;
  glTexGenfv: _glTexGenfv_ProcDeff absolute _glTexGenfv_Addr;
  glTexGeni: _glTexGeni_ProcDeff absolute _glTexGeni_Addr;
  glTexGeniv: _glTexGeniv_ProcDeff absolute _glTexGeniv_Addr;
  glTexImage1D: _glTexImage1D_ProcDeff absolute _glTexImage1D_Addr;
  glTexImage2D: _glTexImage2D_ProcDeff absolute _glTexImage2D_Addr;
  glTexParameterf: _glTexParameterf_ProcDeff absolute _glTexParameterf_Addr;
  glTexParameterfv: _glTexParameterfv_ProcDeff absolute _glTexParameterfv_Addr;
  glTexParameteri: _glTexParameteri_ProcDeff absolute _glTexParameteri_Addr;
  glTexParameteriv: _glTexParameteriv_ProcDeff absolute _glTexParameteriv_Addr;
  glTexSubImage1D: _glTexSubImage1D_ProcDeff absolute _glTexSubImage1D_Addr;
  glTexSubImage2D: _glTexSubImage2D_ProcDeff absolute _glTexSubImage2D_Addr;
  glTranslated: _glTranslated_ProcDeff absolute _glTranslated_Addr;
  glTranslatef: _glTranslatef_ProcDeff absolute _glTranslatef_Addr;
  glVertex2d: _glVertex2d_ProcDeff absolute _glVertex2d_Addr;
  glVertex2dv: _glVertex2dv_ProcDeff absolute _glVertex2dv_Addr;
  glVertex2f: _glVertex2f_ProcDeff absolute _glVertex2f_Addr;
  glVertex2fv: _glVertex2fv_ProcDeff absolute _glVertex2fv_Addr;
  glVertex2i: _glVertex2i_ProcDeff absolute _glVertex2i_Addr;
  glVertex2iv: _glVertex2iv_ProcDeff absolute _glVertex2iv_Addr;
  glVertex2s: _glVertex2s_ProcDeff absolute _glVertex2s_Addr;
  glVertex2sv: _glVertex2sv_ProcDeff absolute _glVertex2sv_Addr;
  glVertex3d: _glVertex3d_ProcDeff absolute _glVertex3d_Addr;
  glVertex3dv: _glVertex3dv_ProcDeff absolute _glVertex3dv_Addr;
  glVertex3f: _glVertex3f_ProcDeff absolute _glVertex3f_Addr;
  glVertex3fv: _glVertex3fv_ProcDeff absolute _glVertex3fv_Addr;
  glVertex3i: _glVertex3i_ProcDeff absolute _glVertex3i_Addr;
  glVertex3iv: _glVertex3iv_ProcDeff absolute _glVertex3iv_Addr;
  glVertex3s: _glVertex3s_ProcDeff absolute _glVertex3s_Addr;
  glVertex3sv: _glVertex3sv_ProcDeff absolute _glVertex3sv_Addr;
  glVertex4d: _glVertex4d_ProcDeff absolute _glVertex4d_Addr;
  glVertex4dv: _glVertex4dv_ProcDeff absolute _glVertex4dv_Addr;
  glVertex4f: _glVertex4f_ProcDeff absolute _glVertex4f_Addr;
  glVertex4fv: _glVertex4fv_ProcDeff absolute _glVertex4fv_Addr;
  glVertex4i: _glVertex4i_ProcDeff absolute _glVertex4i_Addr;
  glVertex4iv: _glVertex4iv_ProcDeff absolute _glVertex4iv_Addr;
  glVertex4s: _glVertex4s_ProcDeff absolute _glVertex4s_Addr;
  glVertex4sv: _glVertex4sv_ProcDeff absolute _glVertex4sv_Addr;
  glVertexPointer: _glVertexPointer_ProcDeff absolute _glVertexPointer_Addr;
  glViewport: _glViewport_ProcDeff absolute _glViewport_Addr;
  // window support functions
  wglGetProcAddress: _wglGetProcAddress_ProcDeff absolute _wglGetProcAddress_Addr;
  wglCopyContext: _wglCopyContext_ProcDeff absolute _wglCopyContext_Addr;
  wglCreateContext: _wglCreateContext_ProcDeff absolute _wglCreateContext_Addr;
  wglCreateLayerContext: _wglCreateLayerContext_ProcDeff absolute _wglCreateLayerContext_Addr;
  wglDeleteContext: _wglDeleteContext_ProcDeff absolute _wglDeleteContext_Addr;
  wglDescribeLayerPlane: _wglDescribeLayerPlane_ProcDeff absolute _wglDescribeLayerPlane_Addr;
  wglGetCurrentContext: _wglGetCurrentContext_ProcDeff absolute _wglGetCurrentContext_Addr;
  wglGetCurrentDC: _wglGetCurrentDC_ProcDeff absolute _wglGetCurrentDC_Addr;
  wglGetLayerPaletteEntries: _wglGetLayerPaletteEntries_ProcDeff absolute _wglGetLayerPaletteEntries_Addr;
  wglMakeCurrent: _wglMakeCurrent_ProcDeff absolute _wglMakeCurrent_Addr;
  wglRealizeLayerPalette: _wglRealizeLayerPalette_ProcDeff absolute _wglRealizeLayerPalette_Addr;
  wglSetLayerPaletteEntries: _wglSetLayerPaletteEntries_ProcDeff absolute _wglSetLayerPaletteEntries_Addr;
  wglShareLists: _wglShareLists_ProcDeff absolute _wglShareLists_Addr;
  wglSwapLayerBuffers: _wglSwapLayerBuffers_ProcDeff absolute _wglSwapLayerBuffers_Addr;
  wglSwapMultipleBuffers: _wglSwapMultipleBuffers_ProcDeff absolute _wglSwapMultipleBuffers_Addr;
  wglUseFontBitmapsA: _wglUseFontBitmapsA_ProcDeff absolute _wglUseFontBitmapsA_Addr;
  wglUseFontOutlinesA: _wglUseFontOutlinesA_ProcDeff absolute _wglUseFontOutlinesA_Addr;
  wglUseFontBitmapsW: _wglUseFontBitmapsW_ProcDeff absolute _wglUseFontBitmapsW_Addr;
  wglUseFontOutlinesW: _wglUseFontOutlinesW_ProcDeff absolute _wglUseFontOutlinesW_Addr;
  wglUseFontBitmaps: _wglUseFontBitmaps_ProcDeff absolute _wglUseFontBitmaps_Addr;
  wglUseFontOutlines: _wglUseFontOutlines_ProcDeff absolute _wglUseFontOutlines_Addr;

  // GL 1.2
  glDrawRangeElements: _glDrawRangeElements_ProcDeff absolute _glDrawRangeElements_Addr;
  glTexImage3D: _glTexImage3D_ProcDeff absolute _glTexImage3D_Addr;

  // GL 1.2 ARB imaging
  glBlendColor: _glBlendColor_ProcDeff absolute _glBlendColor_Addr;
  glBlendEquation: _glBlendEquation_ProcDeff absolute _glBlendEquation_Addr;
  glColorSubTable: _glColorSubTable_ProcDeff absolute _glColorSubTable_Addr;
  glCopyColorSubTable: _glCopyColorSubTable_ProcDeff absolute _glCopyColorSubTable_Addr;
  glColorTable: _glColorTable_ProcDeff absolute _glColorTable_Addr;
  glCopyColorTable: _glCopyColorTable_ProcDeff absolute _glCopyColorTable_Addr;
  glColorTableParameteriv: _glColorTableParameteriv_ProcDeff absolute _glColorTableParameteriv_Addr;
  glColorTableParameterfv: _glColorTableParameterfv_ProcDeff absolute _glColorTableParameterfv_Addr;
  glGetColorTable: _glGetColorTable_ProcDeff absolute _glGetColorTable_Addr;
  glGetColorTableParameteriv: _glGetColorTableParameteriv_ProcDeff absolute _glGetColorTableParameteriv_Addr;
  glGetColorTableParameterfv: _glGetColorTableParameterfv_ProcDeff absolute _glGetColorTableParameterfv_Addr;
  glConvolutionFilter1D: _glConvolutionFilter1D_ProcDeff absolute _glConvolutionFilter1D_Addr;
  glConvolutionFilter2D: _glConvolutionFilter2D_ProcDeff absolute _glConvolutionFilter2D_Addr;
  glCopyConvolutionFilter1D: _glCopyConvolutionFilter1D_ProcDeff absolute _glCopyConvolutionFilter1D_Addr;
  glCopyConvolutionFilter2D: _glCopyConvolutionFilter2D_ProcDeff absolute _glCopyConvolutionFilter2D_Addr;
  glGetConvolutionFilter: _glGetConvolutionFilter_ProcDeff absolute _glGetConvolutionFilter_Addr;
  glSeparableFilter2D: _glSeparableFilter2D_ProcDeff absolute _glSeparableFilter2D_Addr;
  glGetSeparableFilter: _glGetSeparableFilter_ProcDeff absolute _glGetSeparableFilter_Addr;
  glConvolutionParameteri: _glConvolutionParameteri_ProcDeff absolute _glConvolutionParameteri_Addr;
  glConvolutionParameteriv: _glConvolutionParameteriv_ProcDeff absolute _glConvolutionParameteriv_Addr;
  glConvolutionParameterf: _glConvolutionParameterf_ProcDeff absolute _glConvolutionParameterf_Addr;
  glConvolutionParameterfv: _glConvolutionParameterfv_ProcDeff absolute _glConvolutionParameterfv_Addr;
  glGetConvolutionParameteriv: _glGetConvolutionParameteriv_ProcDeff absolute _glGetConvolutionParameteriv_Addr;
  glGetConvolutionParameterfv: _glGetConvolutionParameterfv_ProcDeff absolute _glGetConvolutionParameterfv_Addr;
  glHistogram: _glHistogram_ProcDeff absolute _glHistogram_Addr;
  glResetHistogram: _glResetHistogram_ProcDeff absolute _glResetHistogram_Addr;
  glGetHistogram: _glGetHistogram_ProcDeff absolute _glGetHistogram_Addr;
  glGetHistogramParameteriv: _glGetHistogramParameteriv_ProcDeff absolute _glGetHistogramParameteriv_Addr;
  glGetHistogramParameterfv: _glGetHistogramParameterfv_ProcDeff absolute _glGetHistogramParameterfv_Addr;
  glMinmax: _glMinmax_ProcDeff absolute _glMinmax_Addr;
  glResetMinmax: _glResetMinmax_ProcDeff absolute _glResetMinmax_Addr;
  glGetMinmax: _glGetMinmax_ProcDeff absolute _glGetMinmax_Addr;
  glGetMinmaxParameteriv: _glGetMinmaxParameteriv_ProcDeff absolute _glGetMinmaxParameteriv_Addr;
  glGetMinmaxParameterfv: _glGetMinmaxParameterfv_ProcDeff absolute _glGetMinmaxParameterfv_Addr;

  // GL utility functions and procedures
  gluErrorString: _gluErrorString_ProcDeff absolute _gluErrorString_Addr;
  gluGetString: _gluGetString_ProcDeff absolute _gluGetString_Addr;
  gluOrtho2D: _gluOrtho2D_ProcDeff absolute _gluOrtho2D_Addr;
  gluPerspective: _gluPerspective_ProcDeff absolute _gluPerspective_Addr;
  gluPickMatrix: _gluPickMatrix_ProcDeff absolute _gluPickMatrix_Addr;
  gluLookAt: _gluLookAt_ProcDeff absolute _gluLookAt_Addr;
  gluProject: _gluProject_ProcDeff absolute _gluProject_Addr;
  gluUnProject: _gluUnProject_ProcDeff absolute _gluUnProject_Addr;
  gluScaleImage: _gluScaleImage_ProcDeff absolute _gluScaleImage_Addr;
  gluBuild1DMipmaps: _gluBuild1DMipmaps_ProcDeff absolute _gluBuild1DMipmaps_Addr;
  gluBuild2DMipmaps: _gluBuild2DMipmaps_ProcDeff absolute _gluBuild2DMipmaps_Addr;
  gluNewQuadric: _gluNewQuadric_ProcDeff absolute _gluNewQuadric_Addr;
  gluDeleteQuadric: _gluDeleteQuadric_ProcDeff absolute _gluDeleteQuadric_Addr;
  gluQuadricNormals: _gluQuadricNormals_ProcDeff absolute _gluQuadricNormals_Addr;
  gluQuadricTexture: _gluQuadricTexture_ProcDeff absolute _gluQuadricTexture_Addr;
  gluQuadricOrientation: _gluQuadricOrientation_ProcDeff absolute _gluQuadricOrientation_Addr;
  gluQuadricDrawStyle: _gluQuadricDrawStyle_ProcDeff absolute _gluQuadricDrawStyle_Addr;
  gluCylinder: _gluCylinder_ProcDeff absolute _gluCylinder_Addr;
  gluDisk: _gluDisk_ProcDeff absolute _gluDisk_Addr;
  gluPartialDisk: _gluPartialDisk_ProcDeff absolute _gluPartialDisk_Addr;
  gluSphere: _gluSphere_ProcDeff absolute _gluSphere_Addr;
  gluQuadricCallback: _gluQuadricCallback_ProcDeff absolute _gluQuadricCallback_Addr;
  gluNewTess: _gluNewTess_ProcDeff absolute _gluNewTess_Addr;
  gluDeleteTess: _gluDeleteTess_ProcDeff absolute _gluDeleteTess_Addr;
  gluTessBeginPolygon: _gluTessBeginPolygon_ProcDeff absolute _gluTessBeginPolygon_Addr;
  gluTessBeginContour: _gluTessBeginContour_ProcDeff absolute _gluTessBeginContour_Addr;
  gluTessVertex: _gluTessVertex_ProcDeff absolute _gluTessVertex_Addr;
  gluTessEndContour: _gluTessEndContour_ProcDeff absolute _gluTessEndContour_Addr;
  gluTessEndPolygon: _gluTessEndPolygon_ProcDeff absolute _gluTessEndPolygon_Addr;
  gluTessProperty: _gluTessProperty_ProcDeff absolute _gluTessProperty_Addr;
  gluTessNormal: _gluTessNormal_ProcDeff absolute _gluTessNormal_Addr;
  gluTessCallback: _gluTessCallback_ProcDeff absolute _gluTessCallback_Addr;
  gluGetTessProperty: _gluGetTessProperty_ProcDeff absolute _gluGetTessProperty_Addr;
  gluNewNurbsRenderer: _gluNewNurbsRenderer_ProcDeff absolute _gluNewNurbsRenderer_Addr;
  gluDeleteNurbsRenderer: _gluDeleteNurbsRenderer_ProcDeff absolute _gluDeleteNurbsRenderer_Addr;
  gluBeginSurface: _gluBeginSurface_ProcDeff absolute _gluBeginSurface_Addr;
  gluBeginCurve: _gluBeginCurve_ProcDeff absolute _gluBeginCurve_Addr;
  gluEndCurve: _gluEndCurve_ProcDeff absolute _gluEndCurve_Addr;
  gluEndSurface: _gluEndSurface_ProcDeff absolute _gluEndSurface_Addr;
  gluBeginTrim: _gluBeginTrim_ProcDeff absolute _gluBeginTrim_Addr;
  gluEndTrim: _gluEndTrim_ProcDeff absolute _gluEndTrim_Addr;
  gluPwlCurve: _gluPwlCurve_ProcDeff absolute _gluPwlCurve_Addr;
  gluNurbsCurve: _gluNurbsCurve_ProcDeff absolute _gluNurbsCurve_Addr;
  gluNurbsSurface: _gluNurbsSurface_ProcDeff absolute _gluNurbsSurface_Addr;
  gluLoadSamplingMatrices: _gluLoadSamplingMatrices_ProcDeff absolute _gluLoadSamplingMatrices_Addr;
  gluNurbsProperty: _gluNurbsProperty_ProcDeff absolute _gluNurbsProperty_Addr;
  gluGetNurbsProperty: _gluGetNurbsProperty_ProcDeff absolute _gluGetNurbsProperty_Addr;
  gluNurbsCallback: _gluNurbsCallback_ProcDeff absolute _gluNurbsCallback_Addr;
  gluBeginPolygon: _gluBeginPolygon_ProcDeff absolute _gluBeginPolygon_Addr;
  gluNextContour: _gluNextContour_ProcDeff absolute _gluNextContour_Addr;
  gluEndPolygon: _gluEndPolygon_ProcDeff  absolute _gluEndPolygon_Addr;

  // ARB_multitexture
  glMultiTexCoord1dARB: procedure(target: TGLenum; s: TGLdouble); stdcall;
  glMultiTexCoord1dVARB: procedure(target: TGLenum; v: PGLdouble); stdcall;
  glMultiTexCoord1fARBP: procedure(target: TGLenum; s: TGLfloat); stdcall;
  glMultiTexCoord1fVARB: procedure(target: TGLenum; v: TGLfloat); stdcall;
  glMultiTexCoord1iARB: procedure(target: TGLenum; s: TGLint); stdcall;
  glMultiTexCoord1iVARB: procedure(target: TGLenum; v: PGLInt); stdcall;
  glMultiTexCoord1sARBP: procedure(target: TGLenum; s: TGLshort); stdcall;
  glMultiTexCoord1sVARB: procedure(target: TGLenum; v: PGLshort); stdcall;
  glMultiTexCoord2dARB: procedure(target: TGLenum; s, t: TGLdouble); stdcall;
  glMultiTexCoord2dvARB: procedure(target: TGLenum; v: PGLdouble); stdcall;
  glMultiTexCoord2fARB: procedure(target: TGLenum; s, t: TGLfloat); stdcall;
  glMultiTexCoord2fvARB: procedure(target: TGLenum; v: PGLfloat); stdcall;
  glMultiTexCoord2iARB: procedure(target: TGLenum; s, t: TGLint); stdcall;
  glMultiTexCoord2ivARB: procedure(target: TGLenum; v: PGLint); stdcall;
  glMultiTexCoord2sARB: procedure(target: TGLenum; s, t: TGLshort); stdcall;
  glMultiTexCoord2svARB: procedure(target: TGLenum; v: PGLshort); stdcall;
  glMultiTexCoord3dARB: procedure(target: TGLenum; s, t, r: TGLdouble); stdcall;
  glMultiTexCoord3dvARB: procedure(target: TGLenum; v: PGLdouble); stdcall;
  glMultiTexCoord3fARB: procedure(target: TGLenum; s, t, r: TGLfloat); stdcall;
  glMultiTexCoord3fvARB: procedure(target: TGLenum; v: PGLfloat); stdcall;
  glMultiTexCoord3iARB: procedure(target: TGLenum; s, t, r: TGLint); stdcall;
  glMultiTexCoord3ivARB: procedure(target: TGLenum; v: PGLint); stdcall;
  glMultiTexCoord3sARB: procedure(target: TGLenum; s, t, r: TGLshort); stdcall;
  glMultiTexCoord3svARB: procedure(target: TGLenum; v: PGLshort); stdcall;
  glMultiTexCoord4dARB: procedure(target: TGLenum; s, t, r, q: TGLdouble); stdcall;
  glMultiTexCoord4dvARB: procedure(target: TGLenum; v: PGLdouble); stdcall;
  glMultiTexCoord4fARB: procedure(target: TGLenum; s, t, r, q: TGLfloat); stdcall;
  glMultiTexCoord4fvARB: procedure(target: TGLenum; v: PGLfloat); stdcall;
  glMultiTexCoord4iARB: procedure(target: TGLenum; s, t, r, q: TGLint); stdcall;
  glMultiTexCoord4ivARB: procedure(target: TGLenum; v: PGLint); stdcall;
  glMultiTexCoord4sARB: procedure(target: TGLenum; s, t, r, q: TGLshort); stdcall;
  glMultiTexCoord4svARB: procedure(target: TGLenum; v: PGLshort); stdcall;
  glActiveTextureARB: procedure(target: TGLenum); stdcall;
  glClientActiveTextureARB: procedure(target: TGLenum); stdcall;

  // GLU extensions
  gluNurbsCallbackDataEXT: procedure(nurb: PGLUnurbs; userData: Pointer); stdcall;
  gluNewNurbsTessellatorEXT: function: PGLUnurbs; stdcall;
  gluDeleteNurbsTessellatorEXT: procedure(nurb: PGLUnurbs); stdcall;

  // Extension functions
  glAreTexturesResidentEXT: function(n: TGLsizei; textures: PGLuint; residences: PGLBoolean): TGLboolean; stdcall;
  glArrayElementArrayEXT: procedure(mode: TGLEnum; count: TGLsizei; pi: Pointer); stdcall;
  glBeginSceneEXT: procedure; stdcall;
  glBindTextureEXT: procedure(target: TGLEnum; texture: TGLuint); stdcall;
  glColorTableEXT: procedure(target, internalFormat: TGLEnum; width: TGLsizei; format, atype: TGLEnum;
    data: Pointer); stdcall;
  glColorSubTableExt: procedure(target: TGLEnum; start, count: TGLsizei; format, atype: TGLEnum; data: Pointer); stdcall;
  glCopyTexImage1DEXT: procedure(target: TGLEnum; level: TGLint; internalFormat: TGLEnum; x, y: TGLint;
    width: TGLsizei; border: TGLint); stdcall;
  glCopyTexSubImage1DEXT: procedure(target: TGLEnum; level, xoffset, x, y: TGLint; width: TGLsizei); stdcall;
  glCopyTexImage2DEXT: procedure(target: TGLEnum; level: TGLint; internalFormat: TGLEnum; x, y: TGLint; width,
    height: TGLsizei; border: TGLint); stdcall;
  glCopyTexSubImage2DEXT: procedure(target: TGLEnum; level, xoffset, yoffset, x, y: TGLint; width,
    height: TGLsizei); stdcall;
  glCopyTexSubImage3DEXT: procedure(target: TGLEnum; level, xoffset, yoffset, zoffset, x, y: TGLint; width,
    height: TGLsizei); stdcall;
  glDeleteTexturesEXT: procedure(n: TGLsizei; textures: PGLuint); stdcall;
  glEndSceneEXT: procedure; stdcall;
  glGenTexturesEXT: procedure(n: TGLsizei; textures: PGLuint); stdcall;
  glGetColorTableEXT: procedure(target, format, atype: TGLEnum; data: Pointer); stdcall;
  glGetColorTablePameterfvEXT: procedure(target, pname: TGLEnum; params: Pointer); stdcall;
  glGetColorTablePameterivEXT: procedure(target, pname: TGLEnum; params: Pointer); stdcall;
  glIndexFuncEXT: procedure(func: TGLEnum; ref: TGLfloat); stdcall;
  glIndexMaterialEXT: procedure(face: TGLEnum; mode: TGLEnum); stdcall;
  glIsTextureEXT: function(texture: TGLuint): TGLboolean; stdcall;
  glLockArraysEXT: procedure(first: TGLint; count: TGLsizei); stdcall;
  glPolygonOffsetEXT: procedure(factor, bias: TGLfloat); stdcall;
  glPrioritizeTexturesEXT: procedure(n: TGLsizei; textures: PGLuint; priorities: PGLclampf); stdcall;
  glTexSubImage1DEXT: procedure(target: TGLEnum; level, xoffset: TGLint; width: TGLsizei; format, Atype: TGLEnum;
    pixels: Pointer); stdcall;
  glTexSubImage2DEXT: procedure(target: TGLEnum; level, xoffset, yoffset: TGLint; width, height: TGLsizei; format,
    Atype: TGLEnum; pixels: Pointer); stdcall;
  glTexSubImage3DEXT: procedure(target: TGLEnum; level, xoffset, yoffset, zoffset: TGLint; width, height,
    depth: TGLsizei; format, Atype: TGLEnum; pixels: Pointer); stdcall;
  glUnlockArraysEXT: procedure; stdcall;

  // EXT_vertex_array
  glArrayElementEXT: procedure(I: TGLint); stdcall;
  glColorPointerEXT: procedure(size: TGLInt; atype: TGLenum; stride, count: TGLsizei; data: Pointer); stdcall;
  glDrawArraysEXT: procedure(mode: TGLenum; first: TGLInt; count: TGLsizei); stdcall;
  glEdgeFlagPointerEXT: procedure(stride, count: TGLsizei; data: PGLboolean); stdcall;
  glGetPointervEXT: procedure(pname: TGLEnum; var params); stdcall;
  glIndexPointerEXT: procedure(AType: TGLEnum; stride, count: TGLsizei; P: Pointer); stdcall;
  glNormalPointerEXT: procedure(AType: TGLsizei; stride, count: TGLsizei; P: Pointer); stdcall;
  glTexCoordPointerEXT: procedure(size: TGLint; AType: TGLenum;  stride, count: TGLsizei; P: Pointer); stdcall;
  glVertexPointerEXT: procedure(size: TGLint; AType: TGLenum; stride, count: TGLsizei; P: Pointer); stdcall;

  // EXT_compiled_vertex_array
  glLockArrayEXT: procedure(first: TGLint; count: TGLsizei); stdcall;
  glUnlockArrayEXT: procedure; stdcall;

  // EXT_cull_vertex
  glCullParameterdvEXT: procedure(pname: TGLenum; params: PGLdouble); stdcall;
  glCullParameterfvEXT: procedure(pname: TGLenum; params: PGLfloat); stdcall;

  // WIN_swap_hint
  glAddSwapHintRectWIN: procedure(x, y: TGLint; width, height: TGLsizei); stdcall;

  // EXT_point_parameter
  glPointParameterfEXT: procedure(pname: TGLenum; param: TGLfloat); stdcall;
  glPointParameterfvEXT: procedure(pname: TGLenum; params: PGLfloat); stdcall;

  // GL_ARB_transpose_matrix
  glLoadTransposeMatrixfARB: procedure(m: PGLfloat); stdcall;
  glLoadTransposeMatrixdARB: procedure(m: PGLdouble); stdcall;
  glMultTransposeMatrixfARB: procedure(m: PGLfloat); stdcall;
  glMultTransposeMatrixdARB: procedure(m: PGLdouble); stdcall;

  // GL_ARB_multisample
  glSampleCoverageARB: procedure(Value: TGLclampf; invert: TGLboolean); stdcall;
  glSamplePassARB: procedure(pass: TGLenum); stdcall;

  // GL_ARB_texture_compression
  glCompressedTexImage3DARB: procedure(target: TGLenum; level: TGLint; internalformat: TGLenum;
    Width, Height, depth: TGLsizei; border: TGLint; imageSize: TGLsizei; data: pointer); stdcall;
  glCompressedTexImage2DARB: procedure(target: TGLenum; level: TGLint; internalformat: TGLenum;
    Width, Height: TGLsizei; border: TGLint; imageSize: TGLsizei; data: pointer); stdcall;
  glCompressedTexImage1DARB: procedure(target: TGLenum; level: TGLint; internalformat: TGLenum;
    Width: TGLsizei; border: TGLint; imageSize: TGLsizei; data: pointer); stdcall;
  glCompressedTexSubImage3DARB: procedure(target: TGLenum; level: TGLint; xoffset, yoffset, zoffset: TGLint;
    width, height, depth: TGLsizei; Format: TGLenum; imageSize: TGLsizei; data: pointer); stdcall;
  glCompressedTexSubImage2DARB: procedure(target: TGLenum; level: TGLint; xoffset, yoffset: TGLint;
    width, height: TGLsizei; Format: TGLenum; imageSize: TGLsizei; data: pointer); stdcall;
  glCompressedTexSubImage1DARB: procedure(target: TGLenum; level: TGLint; xoffset: TGLint;
    width: TGLsizei; Format: TGLenum; imageSize: TGLsizei; data: pointer); stdcall;
  glGetCompressedTexImageARB: procedure(target: TGLenum; level: TGLint; img : pointer); stdcall;

  // GL_EXT_blend_color
  glBlendColorEXT: procedure(red, green, blue: TGLclampf; alpha: TGLclampf); stdcall;

  // GL_EXT_texture3D
  glTexImage3DEXT: procedure(target: TGLenum; level: TGLint; internalformat: TGLenum; width, height, depth: TGLsizei;
    border: TGLint; Format, AType : TGLenum; pixels : Pointer); stdcall;

  // GL_SGIS_texture_filter4
  glGetTexFilterFuncSGIS: procedure(target, Filter: TGLenum; weights : PGLfloat); stdcall;
  glTexFilterFuncSGIS: procedure(target, Filter: TGLenum; n: TGLsizei; weights : PGLfloat); stdcall;

  // GL_EXT_histogram
  glGetHistogramEXT: procedure(target: TGLenum; reset: TGLboolean; Format, AType : TGLenum; values: Pointer); stdcall;
  glGetHistogramParameterfvEXT: procedure(target, pname: TGLenum; params: PGLfloat); stdcall;
  glGetHistogramParameterivEXT: procedure(target, pname: TGLenum; params: PGLint); stdcall;
  glGetMinmaxEXT: procedure(target: TGLenum; reset: TGLboolean; Format, AType : TGLenum; values: Pointer); stdcall;
  glGetMinmaxParameterfvEXT: procedure(target, pname: TGLenum; params: PGLfloat); stdcall;
  glGetMinmaxParameterivEXT: procedure(target, pname: TGLenum; params: PGLint); stdcall;
  glHistogramEXT: procedure(target: TGLenum; Width: TGLsizei; internalformat: TGLenum; sink: TGLboolean); stdcall;
  glMinmaxEXT: procedure(target, internalformat: TGLenum; sink: TGLboolean); stdcall;
  glResetHistogramEXT: procedure(target: TGLenum); stdcall;
  glResetMinmaxEXT: procedure(target: TGLenum); stdcall;

  // GL_EXT_convolution
  glConvolutionFilter1DEXT: procedure(target, internalformat: TGLenum; Width: TGLsizei; Format, AType : TGLenum;
    image : Pointer); stdcall;
  glConvolutionFilter2DEXT: procedure(target, internalformat: TGLenum; Width, Height: TGLsizei;
    Format, AType : TGLenum; image : Pointer); stdcall;
  glConvolutionParameterfEXT: procedure(target, pname: TGLenum; params: TGLfloat); stdcall;
  glConvolutionParameterfvEXT: procedure(target, pname: TGLenum; params: PGLfloat); stdcall;
  glConvolutionParameteriEXT: procedure(target, pname: TGLenum; params: TGLint); stdcall;
  glConvolutionParameterivEXT: procedure(target, pname: TGLenum; params: PGLint); stdcall;
  glCopyConvolutionFilter1DEXT: procedure(target, internalformat: TGLenum; x, y: TGLint; Width: TGLsizei); stdcall;
  glCopyConvolutionFilter2DEXT: procedure(target, internalformat: TGLenum; x, y: TGLint; Width, Height: TGLsizei); stdcall;
  glGetConvolutionFilterEXT: procedure(target, Format, AType : TGLenum; image: pointer); stdcall;
  glGetConvolutionParameterfvEXT: procedure(target, pname: TGLenum; params: PGLfloat); stdcall;
  glGetConvolutionParameterivEXT: procedure(target, pname: TGLenum; params: PGLint); stdcall;
  glGetSeparableFilterEXT: procedure(target, Format, AType : TGLenum; row, column, span: Pointer); stdcall;
  glSeparableFilter2DEXT: procedure(target, internalformat: TGLenum; Width, Height: TGLsizei; Format, AType : TGLenum;
    row, column: Pointer); stdcall;

  // GL_SGI_color_table
  glColorTableSGI: procedure(target, internalformat: TGLenum; Width: TGLsizei; Format, AType: TGLenum;
    Table: pointer); stdcall;
  glColorTableParameterfvSGI: procedure(target, pname: TGLenum; params: PGLfloat); stdcall;
  glColorTableParameterivSGI: procedure(target, pname: TGLenum; params: PGLint); stdcall;
  glCopyColorTableSGI: procedure(target, internalformat: TGLenum; x, y: TGLint; Width: TGLsizei); stdcall;
  glGetColorTableSGI: procedure(target, Format, AType : TGLenum; Table: Pointer); stdcall;
  glGetColorTableParameterfvSGI: procedure(target, pname: TGLenum; params: PGLfloat); stdcall;
  glGetColorTableParameterivSGI: procedure(target, pname: TGLenum; params: PGLint); stdcall;

  // GL_SGIX_pixel_texture
  glPixelTexGenSGIX: procedure(mode: TGLenum); stdcall;

  // GL_SGIS_pixel_texture
  glPixelTexGenParameteriSGIS: procedure(pname: TGLenum; param: TGLint); stdcall;
  glPixelTexGenParameterivSGIS: procedure(pname: TGLenum; params: PGLint); stdcall;
  glPixelTexGenParameterfSGIS: procedure(pname: TGLenum; param: TGLfloat); stdcall;
  glPixelTexGenParameterfvSGIS: procedure(pname: TGLenum; params: PGLfloat); stdcall;
  glGetPixelTexGenParameterivSGIS: procedure(pname: TGLenum; params: PGLint); stdcall;
  glGetPixelTexGenParameterfvSGIS: procedure(pname: TGLenum; params: PGLfloat); stdcall;

  // GL_SGIS_texture4D
  glTexImage4DSGIS: procedure(target: TGLenum; level: TGLint; internalformat: TGLenum;
    Width, Height, depth, size4d: TGLsizei; border: TGLint; Format, AType: TGLenum; pixels: Pointer); stdcall;
  glTexSubImage4DSGIS: procedure(target: TGLenum; level, xoffset, yoffset, zoffset, woffset: TGLint;
    Width, Height, depth, size4d: TGLsizei; Format, AType: TGLenum; pixels: Pointer); stdcall;

  // GL_SGIS_detail_texture
  glDetailTexFuncSGIS: procedure(target: TGLenum; n: TGLsizei; points: PGLfloat); stdcall;
  glGetDetailTexFuncSGIS: procedure(target: TGLenum; points: PGLfloat); stdcall;

  // GL_SGIS_sharpen_texture
  glSharpenTexFuncSGIS: procedure(target: TGLenum; n: TGLsizei; points: PGLfloat); stdcall;
  glGetSharpenTexFuncSGIS: procedure(target: TGLenum; points: PGLfloat); stdcall;

  // GL_SGIS_multisample
  glSampleMaskSGIS: procedure(Value: TGLclampf; invert: TGLboolean); stdcall;
  glSamplePatternSGIS: procedure(pattern: TGLenum); stdcall;

  // GL_EXT_blend_minmax
  glBlendEquationEXT: procedure(mode: TGLenum); stdcall;

  // GL_SGIX_sprite
  glSpriteParameterfSGIX: procedure(pname: TGLenum; param: TGLfloat); stdcall;
  glSpriteParameterfvSGIX: procedure(pname: TGLenum; params: PGLfloat); stdcall;
  glSpriteParameteriSGIX: procedure(pname: TGLenum; param: TGLint); stdcall;
  glSpriteParameterivSGIX: procedure(pname: TGLenum; params: PGLint); stdcall;

  // GL_EXT_point_parameters
  glPointParameterfSGIS: procedure(pname: TGLenum; param: TGLfloat); stdcall;
  glPointParameterfvSGIS: procedure(pname: TGLenum; params: PGLfloat); stdcall;

  // GL_SGIX_instruments
  glGetInstrumentsSGIX: procedure; stdcall;
  glInstrumentsBufferSGIX: procedure(Size: TGLsizei; buffer: PGLint); stdcall;
  glPollInstrumentsSGIX: procedure(marker_p: PGLint); stdcall;
  glReadInstrumentsSGIX: procedure(marker: TGLint); stdcall;
  glStartInstrumentsSGIX: procedure; stdcall;
  glStopInstrumentsSGIX: procedure(marker: TGLint); stdcall;

  // GL_SGIX_framezoom
  glFrameZoomSGIX: procedure(factor: TGLint); stdcall;

  // GL_SGIX_tag_sample_buffer
  glTagSampleBufferSGIX: procedure; stdcall;

  // GL_SGIX_polynomial_ffd
  glDeformationMap3dSGIX: procedure(target: TGLenum; u1, u2 : TGLdouble; ustride, uorder: TGLint;
    v1, v2: TGLdouble; vstride, vorder: TGLint; w1, w2: TGLdouble; wstride, worder: TGLint; points: PGLdouble); stdcall;
  glDeformationMap3fSGIX: procedure(target: TGLenum; u1, u2 : TGLfloat; ustride, uorder: TGLint;
    v1, v2: TGLfloat; vstride, vorder: TGLint; w1, w2: TGLfloat; wstride, worder: TGLint; points: PGLfloat); stdcall;
  glDeformSGIX: procedure(mask: TGLbitfield); stdcall;
  glLoadIdentityDeformationMapSGIX: procedure(mask: TGLbitfield); stdcall;

  // GL_SGIX_reference_plane
  glReferencePlaneSGIX: procedure(equation: PGLdouble); stdcall;

  // GL_SGIX_flush_raster
  glFlushRasterSGIX: procedure; stdcall;

  // GL_SGIS_fog_function
  glFogFuncSGIS: procedure(n: TGLsizei; points: PGLfloat); stdcall;
  glGetFogFuncSGIS: procedure(points: PGLfloat); stdcall;

  // GL_HP_image_transform
  glImageTransformParameteriHP: procedure(target, pname: TGLenum; param: TGLint); stdcall;
  glImageTransformParameterfHP: procedure(target, pname: TGLenum; param: TGLfloat); stdcall;
  glImageTransformParameterivHP: procedure(target, pname: TGLenum; params: PGLint); stdcall;
  glImageTransformParameterfvHP: procedure(target, pname: TGLenum; params: PGLfloat); stdcall;
  glGetImageTransformParameterivHP: procedure(target, pname: TGLenum; params: PGLint); stdcall;
  glGetImageTransformParameterfvHP: procedure(target, pname: TGLenum; params: PGLfloat); stdcall;

  // GL_EXT_color_subtable
  glCopyColorSubTableEXT: procedure(target: TGLenum; start: TGLsizei; x, y: TGLint; Width: TGLsizei); stdcall;

  // GL_PGI_misc_hints
  glHintPGI: procedure(target: TGLenum; mode: TGLint); stdcall;

  // GL_EXT_paletted_texture
  glGetColorTableParameterivEXT: procedure(target, pname: TGLenum; params: PGLint); stdcall;
  glGetColorTableParameterfvEXT: procedure(target, pname: TGLenum; params: PGLfloat); stdcall;

  // GL_SGIX_list_priority
  glGetListParameterfvSGIX: procedure(list: TGLuint; pname: TGLenum; params: PGLfloat); stdcall;
  glGetListParameterivSGIX: procedure(list: TGLuint; pname: TGLenum; params: PGLint); stdcall;
  glListParameterfSGIX: procedure(list: TGLuint; pname: TGLenum; param: TGLfloat); stdcall;
  glListParameterfvSGIX: procedure(list: TGLuint; pname: TGLenum; params: PGLfloat); stdcall;
  glListParameteriSGIX: procedure(list: TGLuint; pname: TGLenum; param: TGLint); stdcall;
  glListParameterivSGIX: procedure(list: TGLuint; pname: TGLenum; params: PGLint); stdcall;

  // GL_SGIX_fragment_lighting
  glFragmentColorMaterialSGIX: procedure(face, mode: TGLenum); stdcall;
  glFragmentLightfSGIX: procedure(light, pname: TGLenum; param: TGLfloat); stdcall;
  glFragmentLightfvSGIX: procedure(light, pname: TGLenum; params: PGLfloat); stdcall;
  glFragmentLightiSGIX: procedure(light, pname: TGLenum; param: TGLint); stdcall;
  glFragmentLightivSGIX: procedure(light, pname: TGLenum; params: PGLint); stdcall;
  glFragmentLightModelfSGIX: procedure(pname: TGLenum; param: TGLfloat); stdcall;
  glFragmentLightModelfvSGIX: procedure(pname: TGLenum; params: PGLfloat); stdcall;
  glFragmentLightModeliSGIX: procedure(pname: TGLenum; param: TGLint); stdcall;
  glFragmentLightModelivSGIX: procedure(pname: TGLenum; params: PGLint); stdcall;
  glFragmentMaterialfSGIX: procedure(face, pname: TGLenum; param: TGLfloat); stdcall;
  glFragmentMaterialfvSGIX: procedure(face, pname: TGLenum; params: PGLfloat); stdcall;
  glFragmentMaterialiSGIX: procedure(face, pname: TGLenum; param: TGLint); stdcall;
  glFragmentMaterialivSGIX: procedure(face, pname: TGLenum; params: PGLint); stdcall;
  glGetFragmentLightfvSGIX: procedure(light, pname: TGLenum; params: PGLfloat); stdcall;
  glGetFragmentLightivSGIX: procedure(light, pname: TGLenum; params: PGLint); stdcall;
  glGetFragmentMaterialfvSGIX: procedure(face, pname: TGLenum; params: PGLint); stdcall;
  glGetFragmentMaterialivSGIX: procedure(face, pname: TGLenum; params: PGLint); stdcall;
  glLightEnviSGIX: procedure(pname: TGLenum; param: TGLint); stdcall;

  // GL_EXT_draw_range_elements
  glDrawRangeElementsEXT: procedure(mode: TGLenum; start, Aend: TGLuint; Count: TGLsizei; Atype: TGLenum; indices: Pointer); stdcall;

  // GL_EXT_light_texture
  glApplyTextureEXT: procedure(mode: TGLenum); stdcall;
  glTextureLightEXT: procedure(pname: TGLenum); stdcall;
  glTextureMaterialEXT: procedure(face, mode: TGLenum); stdcall;

  // GL_SGIX_async
  glAsyncMarkerSGIX: procedure(marker: TGLuint); stdcall;
  glFinishAsyncSGIX: procedure(markerp: PGLuint); stdcall;
  glPollAsyncSGIX: procedure(markerp: PGLuint); stdcall;
  glGenAsyncMarkersSGIX: procedure(range: TGLsizei); stdcall;
  glDeleteAsyncMarkersSGIX: procedure(marker: TGLuint; range: TGLsizei); stdcall;
  glIsAsyncMarkerSGIX: procedure(marker: TGLuint); stdcall;

  // GL_INTEL_parallel_arrays
  glVertexPointervINTEL: procedure(size: TGLint; Atype: TGLenum; var P); stdcall;
  glNormalPointervINTEL: procedure(Atype: TGLenum; var P); stdcall;
  glColorPointervINTEL: procedure(size: TGLint; Atype: TGLenum; var P); stdcall;
  glTexCoordPointervINTEL: procedure(size: TGLint; Atype: TGLenum; var P); stdcall;

  // GL_EXT_pixel_transform
  glPixelTransformParameteriEXT: procedure(target, pname: TGLenum; param: TGLint); stdcall;
  glPixelTransformParameterfEXT: procedure(target, pname: TGLenum; param: TGLfloat); stdcall;
  glPixelTransformParameterivEXT: procedure(target, pname: TGLenum; params: PGLint); stdcall;
  glPixelTransformParameterfvEXT: procedure(target, pname: TGLenum; params: PGLfloat); stdcall;

  // GL_EXT_secondary_color
  glSecondaryColor3bEXT: procedure(red, green, blue: TGLbyte); stdcall;
  glSecondaryColor3bvEXT: procedure(v: PGLbyte); stdcall;
  glSecondaryColor3dEXT: procedure(red, green, blue: TGLdouble); stdcall;
  glSecondaryColor3dvEXT: procedure(v: PGLdouble); stdcall;
  glSecondaryColor3fEXT: procedure(red, green, blue: TGLfloat); stdcall;
  glSecondaryColor3fvEXT: procedure(v: PGLfloat); stdcall;
  glSecondaryColor3iEXT: procedure(red, green, blue: TGLint); stdcall;
  glSecondaryColor3ivEXT: procedure(v: PGLint); stdcall;

  glSecondaryColor3sEXT: procedure(red, green, blue: TGLshort); stdcall;
  glSecondaryColor3svEXT: procedure(v: PGLshort); stdcall;
  glSecondaryColor3ubEXT: procedure(red, green, blue: TGLubyte); stdcall;
  glSecondaryColor3ubvEXT: procedure(v: PGLubyte); stdcall;
  glSecondaryColor3uiEXT: procedure(red, green, blue: TGLuint); stdcall;
  glSecondaryColor3uivEXT: procedure(v: PGLuint); stdcall;
  glSecondaryColor3usEXT: procedure(red, green, blue: TGLushort); stdcall;
  glSecondaryColor3usvEXT: procedure(v: PGLushort); stdcall;
  glSecondaryColorPointerEXT: procedure(Size: TGLint; Atype: TGLenum; stride: TGLsizei; p: pointer); stdcall;

  // GL_EXT_texture_perturb_normal
  glTextureNormalEXT: procedure(mode: TGLenum); stdcall;

  // GL_EXT_multi_draw_arrays
  glMultiDrawArraysEXT: procedure(mode: TGLenum; First: PGLint; Count: PGLsizei; primcount: TGLsizei); stdcall;
  glMultiDrawElementsEXT: procedure(mode: TGLenum; Count: PGLsizei; AType: TGLenum; var indices; primcount: TGLsizei); stdcall;

  // GL_EXT_fog_coord
  glFogCoordfEXT: procedure(coord: TGLfloat); stdcall;
  glFogCoordfvEXT: procedure(coord: PGLfloat); stdcall;
  glFogCoorddEXT: procedure(coord: TGLdouble); stdcall;
  glFogCoorddvEXT: procedure(coord: PGLdouble); stdcall;
  glFogCoordPointerEXT: procedure(AType: TGLenum; stride: TGLsizei; p: Pointer); stdcall;

  // GL_EXT_coordinate_frame
  glTangent3bEXT: procedure(tx, ty, tz : TGLbyte); stdcall;
  glTangent3bvEXT: procedure(v: PGLbyte); stdcall;
  glTangent3dEXT: procedure(tx, ty, tz : TGLdouble); stdcall;
  glTangent3dvEXT: procedure(v: PGLdouble); stdcall;
  glTangent3fEXT: procedure(tx, ty, tz : TGLfloat); stdcall;
  glTangent3fvEXT: procedure(v: PGLfloat); stdcall;
  glTangent3iEXT: procedure(tx, ty, tz : TGLint); stdcall;
  glTangent3ivEXT: procedure(v: PGLint); stdcall;
  glTangent3sEXT: procedure(tx, ty, tz : TGLshort); stdcall;
  glTangent3svEXT: procedure(v: PGLshort); stdcall;

  glBinormal3bEXT: procedure(bx, by, bz : TGLbyte); stdcall;
  glBinormal3bvEXT: procedure(v: PGLbyte); stdcall;
  glBinormal3dEXT: procedure(bx, by, bz : TGLdouble); stdcall;
  glBinormal3dvEXT: procedure(v: PGLdouble); stdcall;
  glBinormal3fEXT: procedure(bx, by, bz : TGLfloat); stdcall;
  glBinormal3fvEXT: procedure(v: PGLfloat); stdcall;
  glBinormal3iEXT: procedure(bx, by, bz : TGLint); stdcall;
  glBinormal3ivEXT: procedure(v: PGLint); stdcall;
  glBinormal3sEXT: procedure(bx, by, bz : TGLshort); stdcall;
  glBinormal3svEXT: procedure(v: PGLshort); stdcall;
  glTangentPointerEXT: procedure(Atype: TGLenum; stride: TGLsizei; p: Pointer); stdcall;
  glBinormalPointerEXT: procedure(Atype: TGLenum; stride: TGLsizei; p: Pointer); stdcall;

  // GL_SUNX_constant_data
  glFinishTextureSUNX: procedure; stdcall;

  // GL_SUN_global_alpha
  glGlobalAlphaFactorbSUN: procedure(factor: TGLbyte); stdcall;
  glGlobalAlphaFactorsSUN: procedure(factor: TGLshort); stdcall;
  glGlobalAlphaFactoriSUN: procedure(factor: TGLint); stdcall;
  glGlobalAlphaFactorfSUN: procedure(factor: TGLfloat); stdcall;
  glGlobalAlphaFactordSUN: procedure(factor: TGLdouble); stdcall;
  glGlobalAlphaFactorubSUN: procedure(factor: TGLubyte); stdcall;
  glGlobalAlphaFactorusSUN: procedure(factor: TGLushort); stdcall;
  glGlobalAlphaFactoruiSUN: procedure(factor: TGLuint); stdcall;

  // GL_SUN_triangle_list
  glReplacementCodeuiSUN: procedure(code: TGLuint); stdcall;
  glReplacementCodeusSUN: procedure(code: TGLushort); stdcall;
  glReplacementCodeubSUN: procedure(code: TGLubyte); stdcall;
  glReplacementCodeuivSUN: procedure(code: PGLuint); stdcall;
  glReplacementCodeusvSUN: procedure(code: PGLushort); stdcall;
  glReplacementCodeubvSUN: procedure(code: PGLubyte); stdcall;
  glReplacementCodePointerSUN: procedure(Atype: TGLenum; stride: TGLsizei; var p); stdcall;

  // GL_SUN_vertex
  glColor4ubVertex2fSUN: procedure(r, g, b, a: TGLubyte; x, y: TGLfloat); stdcall;
  glColor4ubVertex2fvSUN: procedure(c: PGLubyte; v: PGLfloat); stdcall;
  glColor4ubVertex3fSUN: procedure(r, g, b, a: TGLubyte; x, y, z: TGLfloat); stdcall;
  glColor4ubVertex3fvSUN: procedure(c: PGLubyte; v: PGLfloat); stdcall;
  glColor3fVertex3fSUN: procedure(r, g, b, x, y, z: TGLfloat); stdcall;
  glColor3fVertex3fvSUN: procedure(c, v: PGLfloat); stdcall;
  glNormal3fVertex3fSUN: procedure(nx, ny, nz: TGLfloat; x, y, z: TGLfloat); stdcall;
  glNormal3fVertex3fvSUN: procedure(n, v: PGLfloat); stdcall;
  glColor4fNormal3fVertex3fSUN: procedure(r, g, b, a, nx, ny, nz, x, y, z: TGLfloat); stdcall;
  glColor4fNormal3fVertex3fvSUN: procedure(c, n, v: PGLfloat); stdcall;
  glTexCoord2fVertex3fSUN: procedure(s, t, x, y, z: TGLfloat); stdcall;
  glTexCoord2fVertex3fvSUN: procedure(tc, v: PGLfloat); stdcall;
  glTexCoord4fVertex4fSUN: procedure(s, t, p, q, x, y, z, w: TGLfloat); stdcall;
  glTexCoord4fVertex4fvSUN: procedure(tc, v: PGLfloat); stdcall;
  glTexCoord2fColor4ubVertex3fSUN: procedure(s, t, r, g, b, a, x, y, z: TGLfloat); stdcall;
  glTexCoord2fColor4ubVertex3fvSUN: procedure(tc: PGLfloat; c: PGLubyte; v: PGLfloat); stdcall;
  glTexCoord2fColor3fVertex3fSUN: procedure(s, t, r, g, b, x, y, z: TGLfloat); stdcall;
  glTexCoord2fColor3fVertex3fvSUN: procedure(tc, c, v: PGLfloat); stdcall;
  glTexCoord2fNormal3fVertex3fSUN: procedure(s, t, nx, ny, nz, x, y, z : TGLfloat); stdcall;
  glTexCoord2fNormal3fVertex3fvSUN: procedure(tc, n, v: PGLfloat); stdcall;
  glTexCoord2fColor4fNormal3fVertex3fSUN: procedure(s, t, r, g, b, a, nx, ny, nz, x, y, z: TGLfloat); stdcall;
  glTexCoord2fColor4fNormal3fVertex3fvSUN: procedure(tc, c, n, v: PGLfloat); stdcall;
  glTexCoord4fColor4fNormal3fVertex4fSUN: procedure(s, t, p, q, r, g, b, a, nx, ny, nz,
    x, y, z, w: TGLfloat); stdcall;
  glTexCoord4fColor4fNormal3fVertex4fvSUN: procedure(tc, c, n, v: PGLfloat); stdcall;
  glReplacementCodeuiVertex3fSUN: procedure(rc: TGLenum; x, y, z: TGLfloat); stdcall;
  glReplacementCodeuiVertex3fvSUN: procedure(rc: PGLenum; v: PGLfloat); stdcall;
  glReplacementCodeuiColor4ubVertex3fSUN: procedure(rc: TGLenum; r, g, b, a: TGLubyte; x, y, z: TGLfloat); stdcall;
  glReplacementCodeuiColor4ubVertex3fvSUN: procedure(rc: PGLenum; c: PGLubyte; v: PGLfloat); stdcall;
  glReplacementCodeuiColor3fVertex3fSUN: procedure(rc: TGLenum; r, g, b, x, y, z: TGLfloat); stdcall;
  glReplacementCodeuiColor3fVertex3fvSUN: procedure(rc: PGLenum; c, v: PGLfloat); stdcall;
  glReplacementCodeuiNormal3fVertex3fSUN: procedure(rc: TGLenum; nx, ny, nz, x, y, z: TGLfloat); stdcall;
  glReplacementCodeuiNormal3fVertex3fvSUN: procedure(rc: PGLenum; n, v: PGLfloat); stdcall;
  glReplacementCodeuiColor4fNormal3fVertex3fSUN: procedure(rc: TGLenum; r, g, b, a, nx, ny, nz,
    x, y, z: TGLfloat); stdcall;
  glReplacementCodeuiColor4fNormal3fVertex3fvSUN: procedure(rc: PGLenum; c, n, v: PGLfloat); stdcall;
  glReplacementCodeuiTexCoord2fVertex3fSUN: procedure(rc: TGLenum; s, t, x, y, z: TGLfloat); stdcall;
  glReplacementCodeuiTexCoord2fVertex3fvSUN: procedure(rc: PGLenum; tc, v: PGLfloat); stdcall;
  glReplacementCodeuiTexCoord2fNormal3fVertex3fSUN: procedure(rc: TGLenum; s, t, nx, ny, nz,
    x, y, z: TGLfloat); stdcall;
  glReplacementCodeuiTexCoord2fNormal3fVertex3fvSUN: procedure(rc: PGLenum; tc, n, v: PGLfloat); stdcall;
  glReplacementCodeuiTexCoord2fColor4fNormal3fVertex3fSUN: procedure(rc: TGLenum; s, t, r, g, b, a, nx, ny, nz,
    x, y, z: TGLfloat); stdcall;
  glReplacementCodeuiTexCoord2fColor4fNormal3fVertex3fvSUN: procedure(rc: PGLenum; tc, c, n, v: PGLfloat); stdcall;

  // GL_EXT_blend_func_separate
  glBlendFuncSeparateEXT: procedure(sfactorRGB, dfactorRGB, sfactorAlpha, dfactorAlpha: TGLenum); stdcall;

  // GL_EXT_vertex_weighting
  glVertexWeightfEXT: procedure(weight: TGLfloat); stdcall;
  glVertexWeightfvEXT: procedure(weight: PGLfloat); stdcall;
  glVertexWeightPointerEXT: procedure(Size: TGLsizei; Atype: TGLenum; stride: TGLsizei; p: pointer); stdcall;

  // GL_NV_vertex_array_range
  glFlushVertexArrayRangeNV: procedure; stdcall;
  glVertexArrayRangeNV: procedure(Size: TGLsizei; p: pointer); stdcall;
  wglAllocateMemoryNV: function(size: TGLsizei; readFrequency, writeFrequency, priority: Single): Pointer; stdcall;
  wglFreeMemoryNV: procedure(ptr: Pointer); stdcall;

  // GL_NV_register_combiners
  glCombinerParameterfvNV: procedure(pname : TGLenum; params: PGLfloat); stdcall;
  glCombinerParameterfNV: procedure(pname : TGLenum; param: TGLfloat); stdcall;
  glCombinerParameterivNV: procedure(pname : TGLenum; params: PGLint); stdcall;
  glCombinerParameteriNV: procedure(pname : TGLenum; param: TGLint); stdcall;
  glCombinerInputNV: procedure(stage, portion, variable, input, mapping, componentUsage: TGLenum); stdcall;
  glCombinerOutputNV: procedure(stage, portion, abOutput, cdOutput, sumOutput, scale, bias: TGLenum; abDotProduct, cdDotProduct, muxSum: TGLboolean); stdcall;
  glFinalCombinerInputNV: procedure(variable, input, mapping, componentUsage: TGLenum); stdcall;
  glGetCombinerInputParameterfvNV: procedure(stage, portion, variable, pname: TGLenum; params: PGLfloat); stdcall;
  glGetCombinerInputParameterivNV: procedure(stage, portion, variable, pname: TGLenum; params: PGLint); stdcall;
  glGetCombinerOutputParameterfvNV: procedure(stage, portion, pname: TGLenum; params: PGLfloat); stdcall;
  glGetCombinerOutputParameterivNV: procedure(stage, portion, pname: TGLenum; params: PGLint); stdcall;
  glGetFinalCombinerInputParameterfvNV: procedure(variable, pname: TGLenum; params: PGLfloat); stdcall;
  glGetFinalCombinerInputParameterivNV: procedure(variable, pname: TGLenum; params: PGLint); stdcall;

  // GL_MESA_resize_buffers
  glResizeBuffersMESA: procedure; stdcall;

  // GL_MESA_window_pos
  glWindowPos2dMESA: procedure(x, y: TGLdouble); stdcall;
  glWindowPos2dvMESA: procedure(v: PGLdouble) stdcall;
  glWindowPos2fMESA: procedure(x, y: TGLfloat); stdcall;
  glWindowPos2fvMESA: procedure(v: PGLfloat); stdcall;
  glWindowPos2iMESA: procedure(x, y: TGLint); stdcall;
  glWindowPos2ivMESA: procedure(v: PGLint); stdcall;
  glWindowPos2sMESA: procedure(x, y: TGLshort); stdcall;
  glWindowPos2svMESA: procedure(v: PGLshort); stdcall;
  glWindowPos3dMESA: procedure(x, y, z: TGLdouble); stdcall;
  glWindowPos3dvMESA: procedure(v: PGLdouble); stdcall;
  glWindowPos3fMESA: procedure(x, y, z: TGLfloat); stdcall;
  glWindowPos3fvMESA: procedure(v: PGLfloat); stdcall;
  glWindowPos3iMESA: procedure(x, y, z: TGLint); stdcall;
  glWindowPos3ivMESA: procedure(v: PGLint); stdcall;
  glWindowPos3sMESA: procedure(x, y, z: TGLshort); stdcall;
  glWindowPos3svMESA: procedure(v: PGLshort); stdcall;
  glWindowPos4dMESA: procedure(x, y, z, w: TGLdouble); stdcall;
  glWindowPos4dvMESA: procedure(v: PGLdouble); stdcall;
  glWindowPos4fMESA: procedure(x, y, z, w: TGLfloat); stdcall;
  glWindowPos4fvMESA: procedure(v: PGLfloat); stdcall;
  glWindowPos4iMESA: procedure(x, y, z, w: TGLint); stdcall;
  glWindowPos4ivMESA: procedure(v: PGLint); stdcall;
  glWindowPos4sMESA: procedure(x, y, z, w: TGLshort); stdcall;
  glWindowPos4svMESA: procedure(v: PGLshort); stdcall;

  // GL_IBM_multimode_draw_arrays
  glMultiModeDrawArraysIBM: procedure(mode: TGLenum; First: PGLint; Count: PGLsizei; primcount: TGLsizei; modestride: TGLint); stdcall;
  glMultiModeDrawElementsIBM: procedure(mode: PGLenum; Count: PGLsizei; Atype: TGLenum; var indices; primcount: TGLsizei; modestride: TGLint); stdcall;

  // GL_IBM_vertex_array_lists
  glColorPointerListIBM: procedure(Size: TGLint; Atype: TGLenum; stride: TGLint; var p; ptrstride: TGLint); stdcall;
  glSecondaryColorPointerListIBM: procedure(Size: TGLint; Atype: TGLenum; stride: TGLint; var p; ptrstride: TGLint); stdcall;
  glEdgeFlagPointerListIBM: procedure(stride: TGLint; var p: PGLboolean; ptrstride: TGLint); stdcall;
  glFogCoordPointerListIBM: procedure(Atype: TGLenum; stride: TGLint; var p; ptrstride: TGLint); stdcall;
  glIndexPointerListIBM: procedure(Atype: TGLenum; stride: TGLint; var p; ptrstride: TGLint); stdcall;
  glNormalPointerListIBM: procedure(Atype: TGLenum; stride: TGLint; var p; ptrstride: TGLint); stdcall;
  glTexCoordPointerListIBM: procedure(Size: TGLint; Atype: TGLenum; stride: TGLint; var p; ptrstride: TGLint); stdcall;
  glVertexPointerListIBM:   procedure(Size: TGLint; Atype: TGLenum; stride: TGLint; var p; ptrstride: TGLint); stdcall;

  // GL_3DFX_tbuffer
  glTbufferMask3DFX: procedure(mask: TGLuint); stdcall;

  // GL_EXT_multisample
  glSampleMaskEXT: procedure(Value: TGLclampf; invert: TGLboolean); stdcall;
  glSamplePatternEXT: procedure(pattern: TGLenum); stdcall;

  // GL_SGIS_texture_color_mask
  glTextureColorMaskSGIS: procedure(red, green, blue, alpha: TGLboolean); stdcall;

  // GL_SGIX_igloo_interface
  glIglooInterfaceSGIX: procedure(pname: TGLenum; params: pointer); stdcall;

//----------------------------------------------------------------------------------------------------------------------

procedure CloseOpenGL;
function InitOpenGL: Boolean;
procedure InitGLExtensions;

function InitOpenGLFromLibrary(GL_Name, GLU_Name: String): Boolean;
function IsOpenGLInitialized: Boolean;

procedure ActivateRenderingContext(DC: HDC; RC: HGLRC);
function CreateRenderingContext(DC: HDC; Options: TRCOptions; ColorBits, StencilBits, AccumBits, AuxBuffers: Integer;
  Layer: Integer): HGLRC;
procedure DeactivateRenderingContext;
procedure DestroyRenderingContext(RC: HGLRC);
function CurrentRenderingContextDC: HDC;
function CurrentRC: HGLRC;

//procedure PreLoadGLProcAddresses;
procedure ReadExtensions;
procedure ReadImplementationProperties;

//----------------------------------------------------------------------------------------------------------------------

implementation


procedure _DummyProc; forward;

Type
  _TSetupPtocAddr = procedure(ProcName:PChar;const ProcAddr);

  TExtensionsFlag= (fGL_3DFX_multisample,
                    fGL_3DFX_tbuffer,
                    fGL_3DFX_texture_compression_FXT1,
                    fGL_APPLE_specular_vector,
                    fGL_APPLE_transform_hint,
                    fGL_ARB_imaging,
                    fGL_ARB_multisample,
                    fGL_ARB_multitexture,
                    fGL_ARB_texture_compression,
                    fGL_ARB_texture_cube_map,
                    fGL_ARB_transpose_matrix,
                    fGL_ARB_vertex_blend,
                    fGL_EXT_422_pixels,
                    fGL_EXT_abgr,
                    fGL_EXT_bgra,
                    fGL_EXT_blend_color,
                    fGL_EXT_blend_func_separate,
                    fGL_EXT_blend_logic_op,
                    fGL_EXT_blend_minmax,
                    fGL_EXT_blend_subtract,
                    fGL_EXT_clip_volume_hint,
                    fGL_EXT_cmyka,
                    fGL_EXT_color_subtable,
                    fGL_EXT_compiled_vertex_array,
                    fGL_EXT_convolution,
                    fGL_EXT_coordinate_frame,
                    fGL_EXT_copy_texture,
                    fGL_EXT_cull_vertex,
                    fGL_EXT_draw_range_elements,
                    fGL_EXT_fog_coord,
                    fGL_EXT_histogram,
                    fGL_EXT_index_array_formats,
                    fGL_EXT_index_func,
                    fGL_EXT_index_material,
                    fGL_EXT_index_texture,
                    fGL_EXT_light_max_exponent,
                    fGL_EXT_light_texture,
                    fGL_EXT_misc_attribute,
                    fGL_EXT_multi_draw_arrays,
                    fGL_EXT_multisample,
                    fGL_EXT_packed_pixels,
                    fGL_EXT_paletted_texture,
                    fGL_EXT_pixel_transform,
                    fGL_EXT_point_parameters,
                    fGL_EXT_polygon_offset,
                    fGL_EXT_rescale_normal,
                    fGL_EXT_scene_marker,
                    fGL_EXT_secondary_color,
                    fGL_EXT_separate_specular_color,
                    fGL_EXT_shared_texture_palette,
                    fGL_EXT_stencil_wrap,
                    fGL_EXT_subtexture,
                    fGL_EXT_texture_color_table,
                    fGL_EXT_texture_compression_s3tc,
                    fGL_EXT_texture_cube_map,
                    fGL_EXT_texture_edge_clamp,
                    fGL_EXT_texture_env_add,
                    fGL_EXT_texture_env_combine,
                    fGL_EXT_texture_filter_anisotropic,
                    fGL_EXT_texture_lod_bias,
                    fGL_EXT_texture_object,
                    fGL_EXT_texture_perturb_normal,
                    fGL_EXT_texture3D,
                    fGL_EXT_vertex_array,
                    fGL_EXT_vertex_weighting,
                    fGL_FfdMaskSGIX,
                    fGL_HP_convolution_border_modes,
                    fGL_HP_image_transform,
                    fGL_HP_occlusion_test,
                    fGL_HP_texture_lighting,
                    fGL_IBM_cull_vertex,
                    fGL_IBM_multimode_draw_arrays,
                    fGL_IBM_rasterpos_clip,
                    fGL_IBM_vertex_array_lists,
                    fGL_INGR_color_clamp,
                    fGL_INGR_interlace_read,
                    fGL_INTEL_parallel_arrays,
                    fGL_KTX_buffer_region,
                    fGL_MESA_resize_buffers,
                    fGL_MESA_window_pos,
                    fGL_NV_blend_square,
                    fGL_NV_fog_distance,
                    fGL_NV_light_max_exponent,
                    fGL_NV_register_combiners,
                    fGL_NV_texgen_emboss,
                    fGL_NV_texgen_reflection,
                    fGL_NV_texture_env_combine4,
                    fGL_NV_vertex_array_range,
                    fGL_PGI_misc_hints,
                    fGL_PGI_vertex_hints,
                    fGL_REND_screen_coordinates,
                    fGL_SGI_color_matrix,
                    fGL_SGI_color_table,
                    fGL_SGI_depth_pass_instrument,
                    fGL_SGIS_detail_texture,
                    fGL_SGIS_fog_function,
                    fGL_SGIS_generate_mipmap,
                    fGL_SGIS_multisample,
                    fGL_SGIS_multitexture,
                    fGL_SGIS_pixel_texture,
                    fGL_SGIS_point_line_texgen,
                    fGL_SGIS_point_parameters,
                    fGL_SGIS_sharpen_texture,
                    fGL_SGIS_texture_border_clamp,
                    fGL_SGIS_texture_color_mask,
                    fGL_SGIS_texture_edge_clamp,
                    fGL_SGIS_texture_filter4,
                    fGL_SGIS_texture_lod,
                    fGL_SGIS_texture_select,
                    fGL_SGIS_texture4D,
                    fGL_SGIX_async,
                    fGL_SGIX_async_histogram,
                    fGL_SGIX_async_pixel,
                    fGL_SGIX_blend_alpha_minmax,
                    fGL_SGIX_calligraphic_fragment,
                    fGL_SGIX_clipmap,
                    fGL_SGIX_convolution_accuracy,
                    fGL_SGIX_depth_texture,
                    fGL_SGIX_flush_raster,
                    fGL_SGIX_fog_offset,
                    fGL_SGIX_fog_scale,
                    fGL_SGIX_fragment_lighting,
                    fGL_SGIX_framezoom,
                    fGL_SGIX_igloo_interface,
                    fGL_SGIX_instruments,
                    fGL_SGIX_interlace,
                    fGL_SGIX_ir_instrument1,
                    fGL_SGIX_list_priority,
                    fGL_SGIX_pixel_texture,
                    fGL_SGIX_pixel_tiles,
                    fGL_SGIX_polynomial_ffd,
                    fGL_SGIX_reference_plane,
                    fGL_SGIX_resample,
                    fGL_SGIX_shadow,
                    fGL_SGIX_shadow_ambient,
                    fGL_SGIX_sprite,
                    fGL_SGIX_subsample,
                    fGL_SGIX_tag_sample_buffer,
                    fGL_SGIX_texture_add_env,
                    fGL_SGIX_texture_lod_bias,
                    fGL_SGIX_texture_multi_buffer,
                    fGL_SGIX_texture_scale_bias,
                    fGL_SGIX_vertex_preclip,
                    fGL_SGIX_ycrcb,
                    fGL_SGIX_ycrcba,
                    fGL_SUN_convolution_border_modes,
                    fGL_SUN_global_alpha,
                    fGL_SUN_triangle_list,
                    fGL_SUN_vertex,
                    fGL_SUNX_constant_data,
                    fGL_WIN_phong_shading,
                    fGL_WIN_specular_fog,
                    fGL_WIN_swap_hint,
                    fWGL_EXT_swap_control,
                    fGLU_EXT_Texture,
                    fGLU_EXT_object_space_tess,
                    fGLU_EXT_nurbs_tessellator);

  TExtensionsFlags = set of TExtensionsFlag;
///////////////////////////////

threadvar
  LastPixelFormat: Integer;

const
  _ReadExtensions: procedure =_DummyProc;

var
  GLHandle, GLUHandle: HINST;

  CheckedExtensions: TExtensionsFlags;
  CurentExtensions: TExtensionsFlags;

  GL_SBuffer: string;
  GLU_SBuffer: string;

  // These variables must not be thread local otherwise we cannot catch forbidden situations like
  // having a rendering context active in several threads.
  vCurrentDC: HDC;
  vCurrentRC: HGLRC;
  vRCRefCount: Integer;

//----------------------------------------------------------------------------------------------------------------------

procedure GL_SetupProcAddr;
asm
   POP EAX
   PUSH dword ptr [EAX] // сохраняем адрес места, куда положить результат
   lea eax,[eax+4]
   PUSH EAX             // строка для GetProcAddress = имя функции
   PUSH [GLHandle]
   CALL GetProcAddress
   POP EDX
   MOV [EDX], EAX
   PUSH EAX
end;

procedure GLU_SetupProcAddr;
asm
   POP EAX
   PUSH dword ptr [EAX] // сохраняем адрес места, куда положить результат
   lea eax,[eax+4]
   PUSH EAX             // строка для GetProcAddress = имя функции
   PUSH [GLUHandle]
   CALL GetProcAddress
   POP EDX
   MOV [EDX], EAX
   PUSH EAX
end;

procedure _DummyProc;
begin

end;

procedure _Init_glAccum;
asm
    Call GL_SetupProcAddr;
    DD  glAccum
    DB  'glAccum',0
end;

procedure _Init_glAlphaFunc;
asm
    Call GL_SetupProcAddr;
    DD  glAlphaFunc
    DB  'glAlphaFunc',0
end;

procedure _Init_glAreTexturesResident;
asm
    Call GL_SetupProcAddr;
    DD  glAreTexturesResident
    DB  'glAreTexturesResident',0
end;

procedure _Init_glArrayElement;
asm
    Call GL_SetupProcAddr;
    DD  glArrayElement
    DB  'glArrayElement',0
end;

procedure _Init_glBegin;
asm
    CALL GL_SetupProcAddr
    DD  offset glBegin
    DB  'glBegin',0
end;

procedure _Init_glBindTexture;
asm
    CALL GL_SetupProcAddr;
    DD  glBindTexture
    DB  'glBindTexture',0
end;

procedure _Init_glBitmap;
asm
    CALL GL_SetupProcAddr;
    DD  glBitmap
    DB  'glBitmap',0
end;

procedure _Init_glBlendFunc;
asm
    CALL GL_SetupProcAddr;
    DD  glBlendFunc
    DB  'glBlendFunc',0
end;

procedure _Init_glCallList;
asm
    CALL GL_SetupProcAddr;
    DD  glCallList
    DB  'glCallList',0
end;

procedure _Init_glCallLists;
asm
    CALL GL_SetupProcAddr;
    DD  glCallLists
    DB  'glCallLists',0
end;

procedure _Init_glClear;
asm
    CALL GL_SetupProcAddr;
    DD  glClear
    DB  'glClear',0
end;

procedure _Init_glClearAccum;
asm
    CALL GL_SetupProcAddr;
    DD  glClearAccum
    DB  'glClearAccum',0
end;

procedure _Init_glClearColor;
asm
    CALL GL_SetupProcAddr;
    DD  glClearColor
    DB  'glClearColor',0
end;

procedure _Init_glClearDepth;
asm
    CALL GL_SetupProcAddr;
    DD  glClearDepth
    DB  'glClearDepth',0
end;

procedure _Init_glClearIndex;
asm
    CALL GL_SetupProcAddr;
    DD  glClearIndex
    DB  'glClearIndex',0
end;

procedure _Init_glClearStencil;
asm
    CALL GL_SetupProcAddr;
    DD  glClearStencil
    DB  'glClearStencil',0
end;

procedure _Init_glClipPlane;
asm
    CALL GL_SetupProcAddr;
    DD  glClipPlane
    DB  'glClipPlane',0
end;

procedure _Init_glColor3b;
asm
    CALL GL_SetupProcAddr;
    DD  glColor3b
    DB  'glColor3b',0
end;

procedure _Init_glColor3bv;
asm
    CALL GL_SetupProcAddr;
    DD  glColor3bv
    DB  'glColor3bv',0
end;

procedure _Init_glColor3d;
asm
    CALL GL_SetupProcAddr;
    DD  glColor3d
    DB  'glColor3d',0
end;

procedure _Init_glColor3dv;
asm
    CALL GL_SetupProcAddr;
    DD  glColor3dv
    DB  'glColor3dv',0
end;

procedure _Init_glColor3f;
asm
    CALL GL_SetupProcAddr;
    DD  glColor3f
    DB  'glColor3f',0
end;

procedure _Init_glColor3fv;
asm
    CALL GL_SetupProcAddr;
    DD  glColor3fv
    DB  'glColor3fv',0
end;

procedure _Init_glColor3i;
asm
    CALL GL_SetupProcAddr;
    DD  glColor3i
    DB  'glColor3i',0
end;

procedure _Init_glColor3iv;
asm
    CALL GL_SetupProcAddr;
    DD  glColor3iv
    DB  'glColor3iv',0
end;

procedure _Init_glColor3s;
asm
    CALL GL_SetupProcAddr;
    DD  glColor3s
    DB  'glColor3s',0
end;

procedure _Init_glColor3sv;
asm
    CALL GL_SetupProcAddr;
    DD  glColor3sv
    DB  'glColor3sv',0
end;

procedure _Init_glColor3ub;
asm
    CALL GL_SetupProcAddr;
    DD  glColor3ub
    DB  'glColor3ub',0
end;

procedure _Init_glColor3ubv;
asm
    CALL GL_SetupProcAddr;
    DD  glColor3ubv
    DB  'glColor3ubv',0
end;

procedure _Init_glColor3ui;
asm
    CALL GL_SetupProcAddr;
    DD  glColor3ui
    DB  'glColor3ui',0
end;

procedure _Init_glColor3uiv;
asm
    CALL GL_SetupProcAddr;
    DD  glColor3uiv
    DB  'glColor3uiv',0
end;

procedure _Init_glColor3us;
asm
    CALL GL_SetupProcAddr;
    DD  glColor3us
    DB  'glColor3us',0
end;

procedure _Init_glColor3usv;
asm
    CALL GL_SetupProcAddr;
    DD  glColor3usv
    DB  'glColor3usv',0
end;

procedure _Init_glColor4b;
asm
    CALL GL_SetupProcAddr;
    DD  glColor4b
    DB  'glColor4b',0
end;

procedure _Init_glColor4bv;
asm
    CALL GL_SetupProcAddr;
    DD  glColor4bv
    DB  'glColor4bv',0
end;

procedure _Init_glColor4d;
asm
    CALL GL_SetupProcAddr;
    DD  glColor4d
    DB  'glColor4d',0
end;

procedure _Init_glColor4dv;
asm
    CALL GL_SetupProcAddr;
    DD  glColor4dv
    DB  'glColor4dv',0
end;

procedure _Init_glColor4f;
asm
    CALL GL_SetupProcAddr;
    DD  glColor4f
    DB  'glColor4f',0
end;

procedure _Init_glColor4fv;
asm
    CALL GL_SetupProcAddr;
    DD  glColor4fv
    DB  'glColor4fv',0
end;

procedure _Init_glColor4i;
asm
    CALL GL_SetupProcAddr;
    DD  glColor4i
    DB  'glColor4i',0
end;

procedure _Init_glColor4iv;
asm
    CALL GL_SetupProcAddr;
    DD  glColor4iv
    DB  'glColor4iv',0
end;

procedure _Init_glColor4s;
asm
    Call GL_SetupProcAddr;
    DD  glColor4s
    DB  'glColor4s',0
end;

procedure _Init_glColor4sv;
asm
    Call GL_SetupProcAddr;
    DD  glColor4sv
    DB  'glColor4sv',0
end;

procedure _Init_glColor4ub;
asm
    Call GL_SetupProcAddr;
    DD  glColor4ub
    DB  'glColor4ub',0
end;

procedure _Init_glColor4ubv;
asm
    Call GL_SetupProcAddr;
    DD  glColor4ubv
    DB  'glColor4ubv',0
end;

procedure _Init_glColor4ui;
asm
    Call GL_SetupProcAddr;
    DD  glColor4ui
    DB  'glColor4ui',0
end;

procedure _Init_glColor4uiv;
asm
    Call GL_SetupProcAddr;
    DD  glColor4uiv
    DB  'glColor4uiv',0
end;

procedure _Init_glColor4us;
asm
    Call GL_SetupProcAddr;
    DD  glColor4us
    DB  'glColor4us',0
end;

procedure _Init_glColor4usv;
asm
    Call GL_SetupProcAddr;
    DD  glColor4usv
    DB  'glColor4usv',0
end;

procedure _Init_glColorMask;
asm
    Call GL_SetupProcAddr;
    DD  glColorMask
    DB  'glColorMask',0
end;

procedure _Init_glColorMaterial;
asm
    Call GL_SetupProcAddr;
    DD  glColorMaterial
    DB  'glColorMaterial',0
end;

procedure _Init_glColorPointer;
asm
    Call GL_SetupProcAddr;
    DD  glColorPointer
    DB  'glColorPointer',0
end;

procedure _Init_glCopyPixels;
asm
    Call GL_SetupProcAddr;
    DD  glCopyPixels
    DB  'glCopyPixels',0
end;

procedure _Init_glCopyTexImage1D;
asm
    Call GL_SetupProcAddr;
    DD  glCopyTexImage1D
    DB  'glCopyTexImage1D',0
end;

procedure _Init_glCopyTexImage2D;
asm
    Call GL_SetupProcAddr;
    DD  glCopyTexImage2D
    DB  'glCopyTexImage2D',0
end;

procedure _Init_glCopyTexSubImage1D;
asm
    Call GL_SetupProcAddr;
    DD  glCopyTexSubImage1D
    DB  'glCopyTexSubImage1D',0
end;

procedure _Init_glCopyTexSubImage2D;
asm
    Call GL_SetupProcAddr;
    DD  glCopyTexSubImage2D
    DB  'glCopyTexSubImage2D',0
end;

procedure _Init_glCullFace;
asm
    Call GL_SetupProcAddr;
    DD  glCullFace
    DB  'glCullFace',0
end;

procedure _Init_glDeleteLists;
asm
    Call GL_SetupProcAddr;
    DD  glDeleteLists
    DB  'glDeleteLists',0
end;

procedure _Init_glDeleteTextures;
asm
    Call GL_SetupProcAddr;
    DD  glDeleteTextures
    DB  'glDeleteTextures',0
end;

procedure _Init_glDepthFunc;
asm
    Call GL_SetupProcAddr;
    DD  glDepthFunc
    DB  'glDepthFunc',0
end;

procedure _Init_glDepthMask;
asm
    Call GL_SetupProcAddr;
    DD  glDepthMask
    DB  'glDepthMask',0
end;

procedure _Init_glDepthRange;
asm
    Call GL_SetupProcAddr;
    DD  glDepthRange
    DB  'glDepthRange',0
end;

procedure _Init_glDisable;
asm
    Call GL_SetupProcAddr;
    DD  glDisable
    DB  'glDisable',0
end;

procedure _Init_glDisableClientState;
asm
    Call GL_SetupProcAddr;
    DD  glDisableClientState
    DB  'glDisableClientState',0
end;

procedure _Init_glDrawArrays;
asm
    Call GL_SetupProcAddr;
    DD  glDrawArrays
    DB  'glDrawArrays',0
end;

procedure _Init_glDrawBuffer;
asm
    Call GL_SetupProcAddr;
    DD  glDrawBuffer
    DB  'glDrawBuffer',0
end;

procedure _Init_glDrawElements;
asm
    Call GL_SetupProcAddr;
    DD  glDrawElements
    DB  'glDrawElements',0
end;

procedure _Init_glDrawPixels;
asm
    Call GL_SetupProcAddr;
    DD  glDrawPixels
    DB  'glDrawPixels',0
end;

procedure _Init_glEdgeFlag;
asm
    Call GL_SetupProcAddr;
    DD  glEdgeFlag
    DB  'glEdgeFlag',0
end;

procedure _Init_glEdgeFlagPointer;
asm
    Call GL_SetupProcAddr;
    DD  glEdgeFlagPointer
    DB  'glEdgeFlagPointer',0
end;

procedure _Init_glEdgeFlagv;
asm
    Call GL_SetupProcAddr;
    DD  glEdgeFlagv
    DB  'glEdgeFlagv',0
end;

procedure _Init_glEnable;
asm
    Call GL_SetupProcAddr;
    DD  glEnable
    DB  'glEnable',0
end;

procedure _Init_glEnableClientState;
asm
    Call GL_SetupProcAddr;
    DD  glEnableClientState
    DB  'glEnableClientState',0
end;

procedure _Init_glEnd;
asm
    Call GL_SetupProcAddr;
    DD  glEnd
    DB  'glEnd',0
end;

procedure _Init_glEndList;
asm
    Call GL_SetupProcAddr;
    DD  glEndList
    DB  'glEndList',0
end;

procedure _Init_glEvalCoord1d;
asm
    Call GL_SetupProcAddr;
    DD  glEvalCoord1d
    DB  'glEvalCoord1d',0
end;

procedure _Init_glEvalCoord1dv;
asm
    Call GL_SetupProcAddr;
    DD  glEvalCoord1dv
    DB  'glEvalCoord1dv',0
end;

procedure _Init_glEvalCoord1f;
asm
    Call GL_SetupProcAddr;
    DD  glEvalCoord1f
    DB  'glEvalCoord1f',0
end;

procedure _Init_glEvalCoord1fv;
asm
    Call GL_SetupProcAddr;
    DD  glEvalCoord1fv
    DB  'glEvalCoord1fv',0
end;

procedure _Init_glEvalCoord2d;
asm
    Call GL_SetupProcAddr;
    DD  glEvalCoord2d
    DB  'glEvalCoord2d',0
end;

procedure _Init_glEvalCoord2dv;
asm
    Call GL_SetupProcAddr;
    DD  glEvalCoord2dv
    DB  'glEvalCoord2dv',0
end;

procedure _Init_glEvalCoord2f;
asm
    Call GL_SetupProcAddr;
    DD  glEvalCoord2f
    DB  'glEvalCoord2f',0
end;

procedure _Init_glEvalCoord2fv;
asm
    Call GL_SetupProcAddr;
    DD  glEvalCoord2fv
    DB  'glEvalCoord2fv',0
end;

procedure _Init_glEvalMesh1;
asm
    Call GL_SetupProcAddr;
    DD  glEvalMesh1
    DB  'glEvalMesh1',0
end;

procedure _Init_glEvalMesh2;
asm
    Call GL_SetupProcAddr;
    DD  glEvalMesh2
    DB  'glEvalMesh2',0
end;

procedure _Init_glEvalPoint1;
asm
    Call GL_SetupProcAddr;
    DD  glEvalPoint1
    DB  'glEvalPoint1',0
end;

procedure _Init_glEvalPoint2;
asm
    Call GL_SetupProcAddr;
    DD  glEvalPoint2
    DB  'glEvalPoint2',0
end;

procedure _Init_glFeedbackBuffer;
asm
    Call GL_SetupProcAddr;
    DD  glFeedbackBuffer
    DB  'glFeedbackBuffer',0
end;

procedure _Init_glFinish;
asm
    Call GL_SetupProcAddr;
    DD  glFinish
    DB  'glFinish',0
end;

procedure _Init_glFlush;
asm
    Call GL_SetupProcAddr;
    DD  glFlush
    DB  'glFlush',0
end;

procedure _Init_glFogf;
asm
    Call GL_SetupProcAddr;
    DD  glFogf
    DB  'glFogf',0
end;

procedure _Init_glFogfv;
asm
    Call GL_SetupProcAddr;
    DD  glFogfv
    DB  'glFogfv',0
end;

procedure _Init_glFogi;
asm
    Call GL_SetupProcAddr;
    DD  glFogi
    DB  'glFogi',0
end;

procedure _Init_glFogiv;
asm
    Call GL_SetupProcAddr;
    DD  glFogiv
    DB  'glFogiv',0
end;

procedure _Init_glFrontFace;
asm
    Call GL_SetupProcAddr;
    DD  glFrontFace
    DB  'glFrontFace',0
end;

procedure _Init_glFrustum;
asm
    Call GL_SetupProcAddr;
    DD  glFrustum
    DB  'glFrustum',0
end;

procedure _Init_glGenLists;
asm
    Call GL_SetupProcAddr;
    DD  glGenLists
    DB  'glGenLists',0
end;

procedure _Init_glGenTextures;
asm
    Call GL_SetupProcAddr;
    DD  glGenTextures
    DB  'glGenTextures',0
end;

procedure _Init_glGetBooleanv;
asm
    Call GL_SetupProcAddr;
    DD  glGetBooleanv
    DB  'glGetBooleanv',0
end;

procedure _Init_glGetClipPlane;
asm
    Call GL_SetupProcAddr;
    DD  glGetClipPlane
    DB  'glGetClipPlane',0
end;

procedure _Init_glGetDoublev;
asm
    Call GL_SetupProcAddr;
    DD  glGetDoublev
    DB  'glGetDoublev',0
end;

procedure _Init_glGetError;
asm
    Call GL_SetupProcAddr;
    DD  glGetError
    DB  'glGetError',0
end;

procedure _Init_glGetFloatv;
asm
    Call GL_SetupProcAddr;
    DD  glGetFloatv
    DB  'glGetFloatv',0
end;

procedure _Init_glGetIntegerv;
asm
    Call GL_SetupProcAddr;
    DD  glGetIntegerv
    DB  'glGetIntegerv',0
end;

procedure _Init_glGetLightfv;
asm
    Call GL_SetupProcAddr;
    DD  glGetLightfv
    DB  'glGetLightfv',0
end;

procedure _Init_glGetLightiv;
asm
    Call GL_SetupProcAddr;
    DD  glGetLightiv
    DB  'glGetLightiv',0
end;

procedure _Init_glGetMapdv;
asm
    Call GL_SetupProcAddr;
    DD  glGetMapdv
    DB  'glGetMapdv',0
end;

procedure _Init_glGetMapfv;
asm
    Call GL_SetupProcAddr;
    DD  glGetMapfv
    DB  'glGetMapfv',0
end;

procedure _Init_glGetMapiv;
asm
    Call GL_SetupProcAddr;
    DD  glGetMapiv
    DB  'glGetMapiv',0
end;

procedure _Init_glGetMaterialfv;
asm
    Call GL_SetupProcAddr;
    DD  glGetMaterialfv
    DB  'glGetMaterialfv',0
end;

procedure _Init_glGetMaterialiv;
asm
    Call GL_SetupProcAddr;
    DD  glGetMaterialiv
    DB  'glGetMaterialiv',0
end;

procedure _Init_glGetPixelMapfv;
asm
    Call GL_SetupProcAddr;
    DD  glGetPixelMapfv
    DB  'glGetPixelMapfv',0
end;

procedure _Init_glGetPixelMapuiv;
asm
    Call GL_SetupProcAddr;
    DD  glGetPixelMapuiv
    DB  'glGetPixelMapuiv',0
end;

procedure _Init_glGetPixelMapusv;
asm
    Call GL_SetupProcAddr;
    DD  glGetPixelMapusv
    DB  'glGetPixelMapusv',0
end;

procedure _Init_glGetPointerv;
asm
    Call GL_SetupProcAddr;
    DD  glGetPointerv
    DB  'glGetPointerv',0
end;

procedure _Init_glGetPolygonStipple;
asm
    Call GL_SetupProcAddr;
    DD  glGetPolygonStipple
    DB  'glGetPolygonStipple',0
end;

procedure _Init_glGetString;
asm
    Call GL_SetupProcAddr;
    DD  glGetString
    DB  'glGetString',0
end;

procedure _Init_glGetTexEnvfv;
asm
    Call GL_SetupProcAddr;
    DD  glGetTexEnvfv
    DB  'glGetTexEnvfv',0
end;

procedure _Init_glGetTexEnviv;
asm
    Call GL_SetupProcAddr;
    DD  glGetTexEnviv
    DB  'glGetTexEnviv',0
end;

procedure _Init_glGetTexGendv;
asm
    Call GL_SetupProcAddr;
    DD  glGetTexGendv
    DB  'glGetTexGendv',0
end;

procedure _Init_glGetTexGenfv;
asm
    Call GL_SetupProcAddr;
    DD  glGetTexGenfv
    DB  'glGetTexGenfv',0
end;

procedure _Init_glGetTexGeniv;
asm
    Call GL_SetupProcAddr;
    DD  glGetTexGeniv
    DB  'glGetTexGeniv',0
end;

procedure _Init_glGetTexImage;
asm
    Call GL_SetupProcAddr;
    DD  glGetTexImage
    DB  'glGetTexImage',0
end;

procedure _Init_glGetTexLevelParameterfv;
asm
    Call GL_SetupProcAddr;
    DD  glGetTexLevelParameterfv
    DB  'glGetTexLevelParameterfv',0
end;

procedure _Init_glGetTexLevelParameteriv;
asm
    Call GL_SetupProcAddr;
    DD  glGetTexLevelParameteriv
    DB  'glGetTexLevelParameteriv',0
end;

procedure _Init_glGetTexParameterfv;
asm
    Call GL_SetupProcAddr;
    DD  glGetTexParameterfv
    DB  'glGetTexParameterfv',0
end;

procedure _Init_glGetTexParameteriv;
asm
    Call GL_SetupProcAddr;
    DD  glGetTexParameteriv
    DB  'glGetTexParameteriv',0
end;

procedure _Init_glHint;
asm
    Call GL_SetupProcAddr;
    DD  glHint
    DB  'glHint',0
end;

procedure _Init_glIndexMask;
asm
    Call GL_SetupProcAddr;
    DD  glIndexMask
    DB  'glIndexMask',0
end;

procedure _Init_glIndexPointer;
asm
    Call GL_SetupProcAddr;
    DD  glIndexPointer
    DB  'glIndexPointer',0
end;

procedure _Init_glIndexd;
asm
    Call GL_SetupProcAddr;
    DD  glIndexd
    DB  'glIndexd',0
end;

procedure _Init_glIndexdv;
asm
    Call GL_SetupProcAddr;
    DD  glIndexdv
    DB  'glIndexdv',0
end;

procedure _Init_glIndexf;
asm
    Call GL_SetupProcAddr;
    DD  glIndexf
    DB  'glIndexf',0
end;

procedure _Init_glIndexfv;
asm
    Call GL_SetupProcAddr;
    DD  glIndexfv
    DB  'glIndexfv',0
end;

procedure _Init_glIndexi;
asm
    Call GL_SetupProcAddr;
    DD  glIndexi
    DB  'glIndexi',0
end;

procedure _Init_glIndexiv;
asm
    Call GL_SetupProcAddr;
    DD  glIndexiv
    DB  'glIndexiv',0
end;

procedure _Init_glIndexs;
asm
    Call GL_SetupProcAddr;
    DD  glIndexs
    DB  'glIndexs',0
end;

procedure _Init_glIndexsv;
asm
    Call GL_SetupProcAddr;
    DD  glIndexsv
    DB  'glIndexsv',0
end;

procedure _Init_glIndexub;
asm
    Call GL_SetupProcAddr;
    DD  glIndexub
    DB  'glIndexub',0
end;

procedure _Init_glIndexubv;
asm
    Call GL_SetupProcAddr;
    DD  glIndexubv
    DB  'glIndexubv',0
end;

procedure _Init_glInitNames;
asm
    Call GL_SetupProcAddr;
    DD  glInitNames
    DB  'glInitNames',0
end;

procedure _Init_glInterleavedArrays;
asm
    Call GL_SetupProcAddr;
    DD  glInterleavedArrays
    DB  'glInterleavedArrays',0
end;

procedure _Init_glIsEnabled;
asm
    Call GL_SetupProcAddr;
    DD  glIsEnabled
    DB  'glIsEnabled',0
end;

procedure _Init_glIsList;
asm
    Call GL_SetupProcAddr;
    DD  glIsList
    DB  'glIsList',0
end;

procedure _Init_glIsTexture;
asm
    Call GL_SetupProcAddr;
    DD  glIsTexture
    DB  'glIsTexture',0
end;

procedure _Init_glLightModelf;
asm
    Call GL_SetupProcAddr;
    DD  glLightModelf
    DB  'glLightModelf',0
end;

procedure _Init_glLightModelfv;
asm
    Call GL_SetupProcAddr;
    DD  glLightModelfv
    DB  'glLightModelfv',0
end;

procedure _Init_glLightModeli;
asm
    Call GL_SetupProcAddr;
    DD  glLightModeli
    DB  'glLightModeli',0
end;

procedure _Init_glLightModeliv;
asm
    Call GL_SetupProcAddr;
    DD  glLightModeliv
    DB  'glLightModeliv',0
end;

procedure _Init_glLightf;
asm
    Call GL_SetupProcAddr;
    DD  glLightf
    DB  'glLightf',0
end;

procedure _Init_glLightfv;
asm
    Call GL_SetupProcAddr;
    DD  glLightfv
    DB  'glLightfv',0
end;

procedure _Init_glLighti;
asm
    Call GL_SetupProcAddr;
    DD  glLighti
    DB  'glLighti',0
end;

procedure _Init_glLightiv;
asm
    Call GL_SetupProcAddr;
    DD  glLightiv
    DB  'glLightiv',0
end;

procedure _Init_glLineStipple;
asm
    Call GL_SetupProcAddr;
    DD  glLineStipple
    DB  'glLineStipple',0
end;

procedure _Init_glLineWidth;
asm
    Call GL_SetupProcAddr;
    DD  glLineWidth
    DB  'glLineWidth',0
end;

procedure _Init_glListBase;
asm
    Call GL_SetupProcAddr;
    DD  glListBase
    DB  'glListBase',0
end;

procedure _Init_glLoadIdentity;
asm
    Call GL_SetupProcAddr;
    DD  glLoadIdentity
    DB  'glLoadIdentity',0
end;

procedure _Init_glLoadMatrixd;
asm
    Call GL_SetupProcAddr;
    DD  glLoadMatrixd
    DB  'glLoadMatrixd',0
end;

procedure _Init_glLoadMatrixf;
asm
    Call GL_SetupProcAddr;
    DD  glLoadMatrixf
    DB  'glLoadMatrixf',0
end;

procedure _Init_glLoadName;
asm
    Call GL_SetupProcAddr;
    DD  glLoadName
    DB  'glLoadName',0
end;

procedure _Init_glLogicOp;
asm
    Call GL_SetupProcAddr;
    DD  glLogicOp
    DB  'glLogicOp',0
end;

procedure _Init_glMap1d;
asm
    Call GL_SetupProcAddr;
    DD  glMap1d
    DB  'glMap1d',0
end;

procedure _Init_glMap1f;
asm
    Call GL_SetupProcAddr;
    DD  glMap1f
    DB  'glMap1f',0
end;

procedure _Init_glMap2d;
asm
    Call GL_SetupProcAddr;
    DD  glMap2d
    DB  'glMap2d',0
end;

procedure _Init_glMap2f;
asm
    Call GL_SetupProcAddr;
    DD  glMap2f
    DB  'glMap2f',0
end;

procedure _Init_glMapGrid1d;
asm
    Call GL_SetupProcAddr;
    DD  glMapGrid1d
    DB  'glMapGrid1d',0
end;

procedure _Init_glMapGrid1f;
asm
    Call GL_SetupProcAddr;
    DD  glMapGrid1f
    DB  'glMapGrid1f',0
end;

procedure _Init_glMapGrid2d;
asm
    Call GL_SetupProcAddr;
    DD  glMapGrid2d
    DB  'glMapGrid2d',0
end;

procedure _Init_glMapGrid2f;
asm
    Call GL_SetupProcAddr;
    DD  glMapGrid2f
    DB  'glMapGrid2f',0
end;

procedure _Init_glMaterialf;
asm
    Call GL_SetupProcAddr;
    DD  glMaterialf
    DB  'glMaterialf',0
end;

procedure _Init_glMaterialfv;
asm
    Call GL_SetupProcAddr;
    DD  glMaterialfv
    DB  'glMaterialfv',0
end;

procedure _Init_glMateriali;
asm
    Call GL_SetupProcAddr;
    DD  glMateriali
    DB  'glMateriali',0
end;

procedure _Init_glMaterialiv;
asm
    Call GL_SetupProcAddr;
    DD  glMaterialiv
    DB  'glMaterialiv',0
end;

procedure _Init_glMatrixMode;
asm
    Call GL_SetupProcAddr;
    DD  glMatrixMode
    DB  'glMatrixMode',0
end;

procedure _Init_glMultMatrixd;
asm
    Call GL_SetupProcAddr;
    DD  glMultMatrixd
    DB  'glMultMatrixd',0
end;

procedure _Init_glMultMatrixf;
asm
    Call GL_SetupProcAddr;
    DD  glMultMatrixf
    DB  'glMultMatrixf',0
end;

procedure _Init_glNewList;
asm
    Call GL_SetupProcAddr;
    DD  glNewList
    DB  'glNewList',0
end;

procedure _Init_glNormal3b;
asm
    Call GL_SetupProcAddr;
    DD  glNormal3b
    DB  'glNormal3b',0
end;

procedure _Init_glNormal3bv;
asm
    Call GL_SetupProcAddr;
    DD  glNormal3bv
    DB  'glNormal3bv',0
end;

procedure _Init_glNormal3d;
asm
    Call GL_SetupProcAddr;
    DD  glNormal3d
    DB  'glNormal3d',0
end;

procedure _Init_glNormal3dv;
asm
    Call GL_SetupProcAddr;
    DD  glNormal3dv
    DB  'glNormal3dv',0
end;

procedure _Init_glNormal3f;
asm
    Call GL_SetupProcAddr;
    DD  glNormal3f
    DB  'glNormal3f',0
end;

procedure _Init_glNormal3fv;
asm
    Call GL_SetupProcAddr;
    DD  glNormal3fv
    DB  'glNormal3fv',0
end;

procedure _Init_glNormal3i;
asm
    Call GL_SetupProcAddr;
    DD  glNormal3i
    DB  'glNormal3i',0
end;

procedure _Init_glNormal3iv;
asm
    Call GL_SetupProcAddr;
    DD  glNormal3iv
    DB  'glNormal3iv',0
end;

procedure _Init_glNormal3s;
asm
    Call GL_SetupProcAddr;
    DD  glNormal3s
    DB  'glNormal3s',0
end;

procedure _Init_glNormal3sv;
asm
    Call GL_SetupProcAddr;
    DD  glNormal3sv
    DB  'glNormal3sv',0
end;

procedure _Init_glNormalPointer;
asm
    Call GL_SetupProcAddr;
    DD  glNormalPointer
    DB  'glNormalPointer',0
end;

procedure _Init_glOrtho;
asm
    Call GL_SetupProcAddr;
    DD  glOrtho
    DB  'glOrtho',0
end;

procedure _Init_glPassThrough;
asm
    Call GL_SetupProcAddr;
    DD  glPassThrough
    DB  'glPassThrough',0
end;

procedure _Init_glPixelMapfv;
asm
    Call GL_SetupProcAddr;
    DD  glPixelMapfv
    DB  'glPixelMapfv',0
end;

procedure _Init_glPixelMapuiv;
asm
    Call GL_SetupProcAddr;
    DD  glPixelMapuiv
    DB  'glPixelMapuiv',0
end;

procedure _Init_glPixelMapusv;
asm
    Call GL_SetupProcAddr;
    DD  glPixelMapusv
    DB  'glPixelMapusv',0
end;

procedure _Init_glPixelStoref;
asm
    Call GL_SetupProcAddr;
    DD  glPixelStoref
    DB  'glPixelStoref',0
end;

procedure _Init_glPixelStorei;
asm
    Call GL_SetupProcAddr;
    DD  glPixelStorei
    DB  'glPixelStorei',0
end;

procedure _Init_glPixelTransferf;
asm
    Call GL_SetupProcAddr;
    DD  glPixelTransferf
    DB  'glPixelTransferf',0
end;

procedure _Init_glPixelTransferi;
asm
    Call GL_SetupProcAddr;
    DD  glPixelTransferi
    DB  'glPixelTransferi',0
end;

procedure _Init_glPixelZoom;
asm
    Call GL_SetupProcAddr;
    DD  glPixelZoom
    DB  'glPixelZoom',0
end;

procedure _Init_glPointSize;
asm
    Call GL_SetupProcAddr;
    DD  glPointSize
    DB  'glPointSize',0
end;

procedure _Init_glPolygonMode;
asm
    Call GL_SetupProcAddr;
    DD  glPolygonMode
    DB  'glPolygonMode',0
end;

procedure _Init_glPolygonOffset;
asm
    Call GL_SetupProcAddr;
    DD  glPolygonOffset
    DB  'glPolygonOffset',0
end;

procedure _Init_glPolygonStipple;
asm
    Call GL_SetupProcAddr;
    DD  glPolygonStipple
    DB  'glPolygonStipple',0
end;

procedure _Init_glPopAttrib;
asm
    Call GL_SetupProcAddr;
    DD  glPopAttrib
    DB  'glPopAttrib',0
end;

procedure _Init_glPopClientAttrib;
asm
    Call GL_SetupProcAddr;
    DD  glPopClientAttrib
    DB  'glPopClientAttrib',0
end;

procedure _Init_glPopMatrix;
asm
    Call GL_SetupProcAddr;
    DD  glPopMatrix
    DB  'glPopMatrix',0
end;

procedure _Init_glPopName;
asm
    Call GL_SetupProcAddr;
    DD  glPopName
    DB  'glPopName',0
end;

procedure _Init_glPrioritizeTextures;
asm
    Call GL_SetupProcAddr;
    DD  glPrioritizeTextures
    DB  'glPrioritizeTextures',0
end;

procedure _Init_glPushAttrib;
asm
    Call GL_SetupProcAddr;
    DD  glPushAttrib
    DB  'glPushAttrib',0
end;

procedure _Init_glPushClientAttrib;
asm
    Call GL_SetupProcAddr;
    DD  glPushClientAttrib
    DB  'glPushClientAttrib',0
end;

procedure _Init_glPushMatrix;
asm
    Call GL_SetupProcAddr;
    DD  glPushMatrix
    DB  'glPushMatrix',0
end;

procedure _Init_glPushName;
asm
    Call GL_SetupProcAddr;
    DD  glPushName
    DB  'glPushName',0
end;

procedure _Init_glRasterPos2d;
asm
    Call GL_SetupProcAddr;
    DD  glRasterPos2d
    DB  'glRasterPos2d',0
end;

procedure _Init_glRasterPos2dv;
asm
    Call GL_SetupProcAddr;
    DD  glRasterPos2dv
    DB  'glRasterPos2dv',0
end;

procedure _Init_glRasterPos2f;
asm
    Call GL_SetupProcAddr;
    DD  glRasterPos2f
    DB  'glRasterPos2f',0
end;

procedure _Init_glRasterPos2fv;
asm
    Call GL_SetupProcAddr;
    DD  glRasterPos2fv
    DB  'glRasterPos2fv',0
end;

procedure _Init_glRasterPos2i;
asm
    Call GL_SetupProcAddr;
    DD  glRasterPos2i
    DB  'glRasterPos2i',0
end;

procedure _Init_glRasterPos2iv;
asm
    Call GL_SetupProcAddr;
    DD  glRasterPos2iv
    DB  'glRasterPos2iv',0
end;

procedure _Init_glRasterPos2s;
asm
    Call GL_SetupProcAddr;
    DD  glRasterPos2s
    DB  'glRasterPos2s',0
end;

procedure _Init_glRasterPos2sv;
asm
    Call GL_SetupProcAddr;
    DD  glRasterPos2sv
    DB  'glRasterPos2sv',0
end;

procedure _Init_glRasterPos3d;
asm
    Call GL_SetupProcAddr;
    DD  glRasterPos3d
    DB  'glRasterPos3d',0
end;

procedure _Init_glRasterPos3dv;
asm
    Call GL_SetupProcAddr;
    DD  glRasterPos3dv
    DB  'glRasterPos3dv',0
end;

procedure _Init_glRasterPos3f;
asm
    Call GL_SetupProcAddr;
    DD  glRasterPos3f
    DB  'glRasterPos3f',0
end;

procedure _Init_glRasterPos3fv;
asm
    Call GL_SetupProcAddr;
    DD  glRasterPos3fv
    DB  'glRasterPos3fv',0
end;

procedure _Init_glRasterPos3i;
asm
    Call GL_SetupProcAddr;
    DD  glRasterPos3i
    DB  'glRasterPos3i',0
end;

procedure _Init_glRasterPos3iv;
asm
    Call GL_SetupProcAddr;
    DD  glRasterPos3iv
    DB  'glRasterPos3iv',0
end;

procedure _Init_glRasterPos3s;
asm
    Call GL_SetupProcAddr;
    DD  glRasterPos3s
    DB  'glRasterPos3s',0
end;

procedure _Init_glRasterPos3sv;
asm
    Call GL_SetupProcAddr;
    DD  glRasterPos3sv
    DB  'glRasterPos3sv',0
end;

procedure _Init_glRasterPos4d;
asm
    Call GL_SetupProcAddr;
    DD  glRasterPos4d
    DB  'glRasterPos4d',0
end;

procedure _Init_glRasterPos4dv;
asm
    Call GL_SetupProcAddr;
    DD  glRasterPos4dv
    DB  'glRasterPos4dv',0
end;

procedure _Init_glRasterPos4f;
asm
    Call GL_SetupProcAddr;
    DD  glRasterPos4f
    DB  'glRasterPos4f',0
end;

procedure _Init_glRasterPos4fv;
asm
    Call GL_SetupProcAddr;
    DD  glRasterPos4fv
    DB  'glRasterPos4fv',0
end;

procedure _Init_glRasterPos4i;
asm
    Call GL_SetupProcAddr;
    DD  glRasterPos4i
    DB  'glRasterPos4i',0
end;

procedure _Init_glRasterPos4iv;
asm
    Call GL_SetupProcAddr;
    DD  glRasterPos4iv
    DB  'glRasterPos4iv',0
end;

procedure _Init_glRasterPos4s;
asm
    Call GL_SetupProcAddr;
    DD  glRasterPos4s
    DB  'glRasterPos4s',0
end;

procedure _Init_glRasterPos4sv;
asm
    Call GL_SetupProcAddr;
    DD  glRasterPos4sv
    DB  'glRasterPos4sv',0
end;

procedure _Init_glReadBuffer;
asm
    Call GL_SetupProcAddr;
    DD  glReadBuffer
    DB  'glReadBuffer',0
end;

procedure _Init_glReadPixels;
asm
    Call GL_SetupProcAddr;
    DD  glReadPixels
    DB  'glReadPixels',0
end;

procedure _Init_glRectd;
asm
    Call GL_SetupProcAddr;
    DD  glRectd
    DB  'glRectd',0
end;

procedure _Init_glRectdv;
asm
    Call GL_SetupProcAddr;
    DD  glRectdv
    DB  'glRectdv',0
end;

procedure _Init_glRectf;
asm
    Call GL_SetupProcAddr;
    DD  glRectf
    DB  'glRectf',0
end;

procedure _Init_glRectfv;
asm
    Call GL_SetupProcAddr;
    DD  glRectfv
    DB  'glRectfv',0
end;

procedure _Init_glRecti;
asm
    Call GL_SetupProcAddr;
    DD  glRecti
    DB  'glRecti',0
end;

procedure _Init_glRectiv;
asm
    Call GL_SetupProcAddr;
    DD  glRectiv
    DB  'glRectiv',0
end;

procedure _Init_glRects;
asm
    Call GL_SetupProcAddr;
    DD  glRects
    DB  'glRects',0
end;

procedure _Init_glRectsv;
asm
    Call GL_SetupProcAddr;
    DD  glRectsv
    DB  'glRectsv',0
end;

procedure _Init_glRenderMode;
asm
    Call GL_SetupProcAddr;
    DD  glRenderMode
    DB  'glRenderMode',0
end;

procedure _Init_glRotated;
asm
    Call GL_SetupProcAddr;
    DD  glRotated
    DB  'glRotated',0
end;

procedure _Init_glRotatef;
asm
    Call GL_SetupProcAddr;
    DD  glRotatef
    DB  'glRotatef',0
end;

procedure _Init_glScaled;
asm
    Call GL_SetupProcAddr;
    DD  glScaled
    DB  'glScaled',0
end;

procedure _Init_glScalef;
asm
    Call GL_SetupProcAddr;
    DD  glScalef
    DB  'glScalef',0
end;

procedure _Init_glScissor;
asm
    Call GL_SetupProcAddr;
    DD  glScissor
    DB  'glScissor',0
end;

procedure _Init_glSelectBuffer;
asm
    Call GL_SetupProcAddr;
    DD  glSelectBuffer
    DB  'glSelectBuffer',0
end;

procedure _Init_glShadeModel;
asm
    Call GL_SetupProcAddr;
    DD  glShadeModel
    DB  'glShadeModel',0
end;

procedure _Init_glStencilFunc;
asm
    Call GL_SetupProcAddr;
    DD  glStencilFunc
    DB  'glStencilFunc',0
end;

procedure _Init_glStencilMask;
asm
    Call GL_SetupProcAddr;
    DD  glStencilMask
    DB  'glStencilMask',0
end;

procedure _Init_glStencilOp;
asm
    Call GL_SetupProcAddr;
    DD  glStencilOp
    DB  'glStencilOp',0
end;

procedure _Init_glTexCoord1d;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord1d
    DB  'glTexCoord1d',0
end;

procedure _Init_glTexCoord1dv;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord1dv
    DB  'glTexCoord1dv',0
end;

procedure _Init_glTexCoord1f;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord1f
    DB  'glTexCoord1f',0
end;

procedure _Init_glTexCoord1fv;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord1fv
    DB  'glTexCoord1fv',0
end;

procedure _Init_glTexCoord1i;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord1i
    DB  'glTexCoord1i',0
end;

procedure _Init_glTexCoord1iv;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord1iv
    DB  'glTexCoord1iv',0
end;

procedure _Init_glTexCoord1s;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord1s
    DB  'glTexCoord1s',0
end;

procedure _Init_glTexCoord1sv;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord1sv
    DB  'glTexCoord1sv',0
end;

procedure _Init_glTexCoord2d;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord2d
    DB  'glTexCoord2d',0
end;

procedure _Init_glTexCoord2dv;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord2dv
    DB  'glTexCoord2dv',0
end;

procedure _Init_glTexCoord2f;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord2f
    DB  'glTexCoord2f',0
end;

procedure _Init_glTexCoord2fv;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord2fv
    DB  'glTexCoord2fv',0
end;

procedure _Init_glTexCoord2i;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord2i
    DB  'glTexCoord2i',0
end;

procedure _Init_glTexCoord2iv;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord2iv
    DB  'glTexCoord2iv',0
end;

procedure _Init_glTexCoord2s;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord2s
    DB  'glTexCoord2s',0
end;

procedure _Init_glTexCoord2sv;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord2sv
    DB  'glTexCoord2sv',0
end;

procedure _Init_glTexCoord3d;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord3d
    DB  'glTexCoord3d',0
end;

procedure _Init_glTexCoord3dv;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord3dv
    DB  'glTexCoord3dv',0
end;

procedure _Init_glTexCoord3f;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord3f
    DB  'glTexCoord3f',0
end;

procedure _Init_glTexCoord3fv;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord3fv
    DB  'glTexCoord3fv',0
end;

procedure _Init_glTexCoord3i;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord3i
    DB  'glTexCoord3i',0
end;

procedure _Init_glTexCoord3iv;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord3iv
    DB  'glTexCoord3iv',0
end;

procedure _Init_glTexCoord3s;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord3s
    DB  'glTexCoord3s',0
end;

procedure _Init_glTexCoord3sv;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord3sv
    DB  'glTexCoord3sv',0
end;

procedure _Init_glTexCoord4d;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord4d
    DB  'glTexCoord4d',0
end;

procedure _Init_glTexCoord4dv;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord4dv
    DB  'glTexCoord4dv',0
end;

procedure _Init_glTexCoord4f;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord4f
    DB  'glTexCoord4f',0
end;

procedure _Init_glTexCoord4fv;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord4fv
    DB  'glTexCoord4fv',0
end;

procedure _Init_glTexCoord4i;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord4i
    DB  'glTexCoord4i',0
end;

procedure _Init_glTexCoord4iv;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord4iv
    DB  'glTexCoord4iv',0
end;

procedure _Init_glTexCoord4s;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord4s
    DB  'glTexCoord4s',0
end;

procedure _Init_glTexCoord4sv;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoord4sv
    DB  'glTexCoord4sv',0
end;

procedure _Init_glTexCoordPointer;
asm
    Call GL_SetupProcAddr;
    DD  glTexCoordPointer
    DB  'glTexCoordPointer',0
end;

procedure _Init_glTexEnvf;
asm
    Call GL_SetupProcAddr;
    DD  glTexEnvf
    DB  'glTexEnvf',0
end;

procedure _Init_glTexEnvfv;
asm
    Call GL_SetupProcAddr;
    DD  glTexEnvfv
    DB  'glTexEnvfv',0
end;

procedure _Init_glTexEnvi;
asm
    Call GL_SetupProcAddr;
    DD  glTexEnvi
    DB  'glTexEnvi',0
end;

procedure _Init_glTexEnviv;
asm
    Call GL_SetupProcAddr;
    DD  glTexEnviv
    DB  'glTexEnviv',0
end;

procedure _Init_glTexGend;
asm
    Call GL_SetupProcAddr;
    DD  glTexGend
    DB  'glTexGend',0
end;

procedure _Init_glTexGendv;
asm
    Call GL_SetupProcAddr;
    DD  glTexGendv
    DB  'glTexGendv',0
end;

procedure _Init_glTexGenf;
asm
    Call GL_SetupProcAddr;
    DD  glTexGenf
    DB  'glTexGenf',0
end;

procedure _Init_glTexGenfv;
asm
    Call GL_SetupProcAddr;
    DD  glTexGenfv
    DB  'glTexGenfv',0
end;

procedure _Init_glTexGeni;
asm
    Call GL_SetupProcAddr;
    DD  glTexGeni
    DB  'glTexGeni',0
end;

procedure _Init_glTexGeniv;
asm
    Call GL_SetupProcAddr;
    DD  glTexGeniv
    DB  'glTexGeniv',0
end;

procedure _Init_glTexImage1D;
asm
    Call GL_SetupProcAddr;
    DD  glTexImage1D
    DB  'glTexImage1D',0
end;

procedure _Init_glTexImage2D;
asm
    Call GL_SetupProcAddr;
    DD  glTexImage2D
    DB  'glTexImage2D',0
end;

procedure _Init_glTexParameterf;
asm
    Call GL_SetupProcAddr;
    DD  glTexParameterf
    DB  'glTexParameterf',0
end;

procedure _Init_glTexParameterfv;
asm
    Call GL_SetupProcAddr;
    DD  glTexParameterfv
    DB  'glTexParameterfv',0
end;

procedure _Init_glTexParameteri;
asm
    Call GL_SetupProcAddr;
    DD  glTexParameteri
    DB  'glTexParameteri',0
end;

procedure _Init_glTexParameteriv;
asm
    Call GL_SetupProcAddr;
    DD  glTexParameteriv
    DB  'glTexParameteriv',0
end;

procedure _Init_glTexSubImage1D;
asm
    Call GL_SetupProcAddr;
    DD  glTexSubImage1D
    DB  'glTexSubImage1D',0
end;

procedure _Init_glTexSubImage2D;
asm
    Call GL_SetupProcAddr;
    DD  glTexSubImage2D
    DB  'glTexSubImage2D',0
end;

procedure _Init_glTranslated;
asm
    Call GL_SetupProcAddr;
    DD  glTranslated
    DB  'glTranslated',0
end;

procedure _Init_glTranslatef;
asm
    Call GL_SetupProcAddr;
    DD  glTranslatef
    DB  'glTranslatef',0
end;

procedure _Init_glVertex2d;
asm
    Call GL_SetupProcAddr;
    DD  glVertex2d
    DB  'glVertex2d',0
end;

procedure _Init_glVertex2dv;
asm
    Call GL_SetupProcAddr;
    DD  glVertex2dv
    DB  'glVertex2dv',0
end;

procedure _Init_glVertex2f;
asm
    Call GL_SetupProcAddr;
    DD  glVertex2f
    DB  'glVertex2f',0
end;

procedure _Init_glVertex2fv;
asm
    Call GL_SetupProcAddr;
    DD  glVertex2fv
    DB  'glVertex2fv',0
end;

procedure _Init_glVertex2i;
asm
    Call GL_SetupProcAddr;
    DD  glVertex2i
    DB  'glVertex2i',0
end;

procedure _Init_glVertex2iv;
asm
    Call GL_SetupProcAddr;
    DD  glVertex2iv
    DB  'glVertex2iv',0
end;

procedure _Init_glVertex2s;
asm
    Call GL_SetupProcAddr;
    DD  glVertex2s
    DB  'glVertex2s',0
end;

procedure _Init_glVertex2sv;
asm
    Call GL_SetupProcAddr;
    DD  glVertex2sv
    DB  'glVertex2sv',0
end;

procedure _Init_glVertex3d;
asm
    Call GL_SetupProcAddr;
    DD  glVertex3d
    DB  'glVertex3d',0
end;

procedure _Init_glVertex3dv;
asm
    Call GL_SetupProcAddr;
    DD  glVertex3dv
    DB  'glVertex3dv',0
end;

procedure _Init_glVertex3f;
asm
    Call GL_SetupProcAddr;
    DD  glVertex3f
    DB  'glVertex3f',0
end;

procedure _Init_glVertex3fv;
asm
    Call GL_SetupProcAddr;
    DD  glVertex3fv
    DB  'glVertex3fv',0
end;

procedure _Init_glVertex3i;
asm
    Call GL_SetupProcAddr;
    DD  glVertex3i
    DB  'glVertex3i',0
end;

procedure _Init_glVertex3iv;
asm
    Call GL_SetupProcAddr;
    DD  glVertex3iv
    DB  'glVertex3iv',0
end;

procedure _Init_glVertex3s;
asm
    Call GL_SetupProcAddr;
    DD  glVertex3s
    DB  'glVertex3s',0
end;

procedure _Init_glVertex3sv;
asm
    Call GL_SetupProcAddr;
    DD  glVertex3sv
    DB  'glVertex3sv',0
end;

procedure _Init_glVertex4d;
asm
    Call GL_SetupProcAddr;
    DD  glVertex4d
    DB  'glVertex4d',0
end;

procedure _Init_glVertex4dv;
asm
    Call GL_SetupProcAddr;
    DD  glVertex4dv
    DB  'glVertex4dv',0
end;

procedure _Init_glVertex4f;
asm
    Call GL_SetupProcAddr;
    DD  glVertex4f
    DB  'glVertex4f',0
end;

procedure _Init_glVertex4fv;
asm
    Call GL_SetupProcAddr;
    DD  glVertex4fv
    DB  'glVertex4fv',0
end;

procedure _Init_glVertex4i;
asm
    Call GL_SetupProcAddr;
    DD  glVertex4i
    DB  'glVertex4i',0
end;

procedure _Init_glVertex4iv;
asm
    Call GL_SetupProcAddr;
    DD  glVertex4iv
    DB  'glVertex4iv',0
end;

procedure _Init_glVertex4s;
asm
    Call GL_SetupProcAddr;
    DD  glVertex4s
    DB  'glVertex4s',0
end;

procedure _Init_glVertex4sv;
asm
    Call GL_SetupProcAddr;
    DD  glVertex4sv
    DB  'glVertex4sv',0
end;

procedure _Init_glVertexPointer;
asm
    Call GL_SetupProcAddr;
    DD  glVertexPointer
    DB  'glVertexPointer',0
end;

procedure _Init_glViewport;
asm
    Call GL_SetupProcAddr;
    DD  glViewport
    DB  'glViewport',0
end;

procedure _Init_wglGetProcAddress;
asm
    Call GL_SetupProcAddr;
    DD  wglGetProcAddress
    DB  'wglGetProcAddress',0
end;

procedure _Init_wglCopyContext;
asm
    Call GL_SetupProcAddr;
    DD  wglCopyContext
    DB  'wglCopyContext',0
end;

procedure _Init_wglCreateContext;
asm
    Call GL_SetupProcAddr;
    DD  wglCreateContext
    DB  'wglCreateContext',0
end;

procedure _Init_wglCreateLayerContext;
asm
    Call GL_SetupProcAddr;
    DD  wglCreateLayerContext
    DB  'wglCreateLayerContext',0
end;

procedure _Init_wglDeleteContext;
asm
    Call GL_SetupProcAddr;
    DD  wglDeleteContext
    DB  'wglDeleteContext',0
end;

procedure _Init_wglDescribeLayerPlane;
asm
    Call GL_SetupProcAddr;
    DD  wglDescribeLayerPlane
    DB  'wglDescribeLayerPlane',0
end;

procedure _Init_wglGetCurrentContext;
asm
    Call GL_SetupProcAddr;
    DD  wglGetCurrentContext
    DB  'wglGetCurrentContext',0
end;

procedure _Init_wglGetCurrentDC;
asm
    Call GL_SetupProcAddr;
    DD  wglGetCurrentDC
    DB  'wglGetCurrentDC',0
end;

procedure _Init_wglGetLayerPaletteEntries;
asm
    Call GL_SetupProcAddr;
    DD  wglGetLayerPaletteEntries
    DB  'wglGetLayerPaletteEntries',0
end;

procedure _Init_wglMakeCurrent;
asm
    Call GL_SetupProcAddr;
    DD  wglMakeCurrent
    DB  'wglMakeCurrent',0
end;

procedure _Init_wglRealizeLayerPalette;
asm
    Call GL_SetupProcAddr;
    DD  wglRealizeLayerPalette
    DB  'wglRealizeLayerPalette',0
end;

procedure _Init_wglSetLayerPaletteEntries;
asm
    Call GL_SetupProcAddr;
    DD  wglSetLayerPaletteEntries
    DB  'wglSetLayerPaletteEntries',0
end;

procedure _Init_wglShareLists;
asm
    Call GL_SetupProcAddr;
    DD  wglShareLists
    DB  'wglShareLists',0
end;

procedure _Init_wglSwapLayerBuffers;
asm
    Call GL_SetupProcAddr;
    DD  wglSwapLayerBuffers
    DB  'wglSwapLayerBuffers',0
end;

procedure _Init_wglSwapMultipleBuffers;
asm
    Call GL_SetupProcAddr;
    DD  wglSwapMultipleBuffers
    DB  'wglSwapMultipleBuffers',0
end;

procedure _Init_wglUseFontBitmapsA;
asm
    Call GL_SetupProcAddr;
    DD  wglUseFontBitmapsA
    DB  'wglUseFontBitmapsA',0
end;

procedure _Init_wglUseFontOutlinesA;
asm
    Call GL_SetupProcAddr;
    DD  wglUseFontOutlinesA
    DB  'wglUseFontOutlinesA',0
end;

procedure _Init_wglUseFontBitmapsW;
asm
    Call GL_SetupProcAddr;
    DD  wglUseFontBitmapsW
    DB  'wglUseFontBitmapsW',0
end;

procedure _Init_wglUseFontOutlinesW;
asm
    Call GL_SetupProcAddr;
    DD  wglUseFontOutlinesW
    DB  'wglUseFontOutlinesW',0
end;

procedure _Init_wglUseFontBitmaps;
asm
    Call GL_SetupProcAddr;
    DD  wglUseFontBitmaps
    DB  'wglUseFontBitmaps',0
end;

procedure _Init_wglUseFontOutlines;
asm
    Call GL_SetupProcAddr;
    DD  wglUseFontOutlines
    DB  'wglUseFontOutlines',0
end;

procedure _Init_glDrawRangeElements;
asm
    Call GL_SetupProcAddr;
    DD  glDrawRangeElements
    DB  'glDrawRangeElements',0
end;

procedure _Init_glTexImage3D;
asm
    Call GL_SetupProcAddr;
    DD  glTexImage3D
    DB  'glTexImage3D',0
end;

procedure _Init_glBlendColor;
asm
    Call GL_SetupProcAddr;
    DD  glBlendColor
    DB  'glBlendColor',0
end;

procedure _Init_glBlendEquation;
asm
    Call GL_SetupProcAddr;
    DD  glBlendEquation
    DB  'glBlendEquation',0
end;

procedure _Init_glColorSubTable;
asm
    Call GL_SetupProcAddr;
    DD  glColorSubTable
    DB  'glColorSubTable',0
end;

procedure _Init_glCopyColorSubTable;
asm
    Call GL_SetupProcAddr;
    DD  glCopyColorSubTable
    DB  'glCopyColorSubTable',0
end;

procedure _Init_glColorTable;
asm
    Call GL_SetupProcAddr;
    DD  glColorTable
    DB  'glColorTable',0
end;

procedure _Init_glCopyColorTable;
asm
    Call GL_SetupProcAddr;
    DD  glCopyColorTable
    DB  'glCopyColorTable',0
end;

procedure _Init_glColorTableParameteriv;
asm
    Call GL_SetupProcAddr;
    DD  glColorTableParameteriv
    DB  'glColorTableParameteriv',0
end;

procedure _Init_glColorTableParameterfv;
asm
    Call GL_SetupProcAddr;
    DD  glColorTableParameterfv
    DB  'glColorTableParameterfv',0
end;

procedure _Init_glGetColorTable;
asm
    Call GL_SetupProcAddr;
    DD  glGetColorTable
    DB  'glGetColorTable',0
end;

procedure _Init_glGetColorTableParameteriv;
asm
    Call GL_SetupProcAddr;
    DD  glGetColorTableParameteriv
    DB  'glGetColorTableParameteriv',0
end;

procedure _Init_glGetColorTableParameterfv;
asm
    Call GL_SetupProcAddr;
    DD  glGetColorTableParameterfv
    DB  'glGetColorTableParameterfv',0
end;

procedure _Init_glConvolutionFilter1D;
asm
    Call GL_SetupProcAddr;
    DD  glConvolutionFilter1D
    DB  'glConvolutionFilter1D',0
end;

procedure _Init_glConvolutionFilter2D;
asm
    Call GL_SetupProcAddr;
    DD  glConvolutionFilter2D
    DB  'glConvolutionFilter2D',0
end;

procedure _Init_glCopyConvolutionFilter1D;
asm
    Call GL_SetupProcAddr;
    DD  glCopyConvolutionFilter1D
    DB  'glCopyConvolutionFilter1D',0
end;

procedure _Init_glCopyConvolutionFilter2D;
asm
    Call GL_SetupProcAddr;
    DD  glCopyConvolutionFilter2D
    DB  'glCopyConvolutionFilter2D',0
end;

procedure _Init_glGetConvolutionFilter;
asm
    Call GL_SetupProcAddr;
    DD  glGetConvolutionFilter
    DB  'glGetConvolutionFilter',0
end;

procedure _Init_glSeparableFilter2D;
asm
    Call GL_SetupProcAddr;
    DD  glSeparableFilter2D
    DB  'glSeparableFilter2D',0
end;

procedure _Init_glGetSeparableFilter;
asm
    Call GL_SetupProcAddr;
    DD  glGetSeparableFilter
    DB  'glGetSeparableFilter',0
end;

procedure _Init_glConvolutionParameteri;
asm
    Call GL_SetupProcAddr;
    DD  glConvolutionParameteri
    DB  'glConvolutionParameteri',0
end;

procedure _Init_glConvolutionParameteriv;
asm
    Call GL_SetupProcAddr;
    DD  glConvolutionParameteriv
    DB  'glConvolutionParameteriv',0
end;

procedure _Init_glConvolutionParameterf;
asm
    Call GL_SetupProcAddr;
    DD  glConvolutionParameterf
    DB  'glConvolutionParameterf',0
end;

procedure _Init_glConvolutionParameterfv;
asm
    Call GL_SetupProcAddr;
    DD  glConvolutionParameterfv
    DB  'glConvolutionParameterfv',0
end;

procedure _Init_glGetConvolutionParameteriv;
asm
    Call GL_SetupProcAddr;
    DD  glGetConvolutionParameteriv
    DB  'glGetConvolutionParameteriv',0
end;

procedure _Init_glGetConvolutionParameterfv;
asm
    Call GL_SetupProcAddr;
    DD  glGetConvolutionParameterfv
    DB  'glGetConvolutionParameterfv',0
end;

procedure _Init_glHistogram;
asm
    Call GL_SetupProcAddr;
    DD  glHistogram
    DB  'glHistogram',0
end;

procedure _Init_glResetHistogram;
asm
    Call GL_SetupProcAddr;
    DD  glResetHistogram
    DB  'glResetHistogram',0
end;

procedure _Init_glGetHistogram;
asm
    Call GL_SetupProcAddr;
    DD  glGetHistogram
    DB  'glGetHistogram',0
end;

procedure _Init_glGetHistogramParameteriv;
asm
    Call GL_SetupProcAddr;
    DD  glGetHistogramParameteriv
    DB  'glGetHistogramParameteriv',0
end;

procedure _Init_glGetHistogramParameterfv;
asm
    Call GL_SetupProcAddr;
    DD  glGetHistogramParameterfv
    DB  'glGetHistogramParameterfv',0
end;

procedure _Init_glMinmax;
asm
    Call GL_SetupProcAddr;
    DD  glMinmax
    DB  'glMinmax',0
end;

procedure _Init_glResetMinmax;
asm
    Call GL_SetupProcAddr;
    DD  glResetMinmax
    DB  'glResetMinmax',0
end;

procedure _Init_glGetMinmax;
asm
    Call GL_SetupProcAddr;
    DD  glGetMinmax
    DB  'glGetMinmax',0
end;

procedure _Init_glGetMinmaxParameteriv;
asm
    Call GL_SetupProcAddr;
    DD  glGetMinmaxParameteriv
    DB  'glGetMinmaxParameteriv',0
end;

procedure _Init_glGetMinmaxParameterfv;
asm
    Call GL_SetupProcAddr;
    DD  glGetMinmaxParameterfv
    DB  'glGetMinmaxParameterfv',0
end;

procedure _Init_gluBeginCurve;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluBeginCurve
    DB  'gluBeginCurve',0
end;

procedure _Init_gluBeginPolygon;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluBeginPolygon
    DB  'gluBeginPolygon',0
end;

procedure _Init_gluBeginSurface;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluBeginSurface
    DB  'gluBeginSurface',0
end;

procedure _Init_gluBeginTrim;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluBeginTrim
    DB  'gluBeginTrim',0
end;

procedure _Init_gluBuild1DMipmaps;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluBuild1DMipmaps
    DB  'gluBuild1DMipmaps',0
end;

procedure _Init_gluBuild2DMipmaps;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluBuild2DMipmaps
    DB  'gluBuild2DMipmaps',0
end;

procedure _Init_gluCylinder;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluCylinder
    DB  'gluCylinder',0
end;

procedure _Init_gluDeleteNurbsRenderer;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluDeleteNurbsRenderer
    DB  'gluDeleteNurbsRenderer',0
end;

procedure _Init_gluDeleteQuadric;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluDeleteQuadric
    DB  'gluDeleteQuadric',0
end;

procedure _Init_gluDeleteTess;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluDeleteTess
    DB  'gluDeleteTess',0
end;

procedure _Init_gluDisk;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluDisk
    DB  'gluDisk',0
end;

procedure _Init_gluEndCurve;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluEndCurve
    DB  'gluEndCurve',0
end;

procedure _Init_gluEndPolygon;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluEndPolygon
    DB  'gluEndPolygon',0
end;

procedure _Init_gluEndSurface;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluEndSurface
    DB  'gluEndSurface',0
end;

procedure _Init_gluEndTrim;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluEndTrim
    DB  'gluEndTrim',0
end;

procedure _Init_gluErrorString;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluErrorString
    DB  'gluErrorString',0
end;

procedure _Init_gluGetNurbsProperty;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluGetNurbsProperty
    DB  'gluGetNurbsProperty',0
end;

procedure _Init_gluGetString;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluGetString
    DB  'gluGetString',0
end;

procedure _Init_gluGetTessProperty;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluGetTessProperty
    DB  'gluGetTessProperty',0
end;

procedure _Init_gluLoadSamplingMatrices;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluLoadSamplingMatrices
    DB  'gluLoadSamplingMatrices',0
end;

procedure _Init_gluLookAt;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluLookAt
    DB  'gluLookAt',0
end;

procedure _Init_gluNewNurbsRenderer;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluNewNurbsRenderer
    DB  'gluNewNurbsRenderer',0
end;

procedure _Init_gluNewQuadric;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluNewQuadric
    DB  'gluNewQuadric',0
end;

procedure _Init_gluNewTess;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluNewTess
    DB  'gluNewTess',0
end;

procedure _Init_gluNextContour;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluNextContour
    DB  'gluNextContour',0
end;

procedure _Init_gluNurbsCallback;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluNurbsCallback
    DB  'gluNurbsCallback',0
end;

procedure _Init_gluNurbsCurve;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluNurbsCurve
    DB  'gluNurbsCurve',0
end;

procedure _Init_gluNurbsProperty;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluNurbsProperty
    DB  'gluNurbsProperty',0
end;

procedure _Init_gluNurbsSurface;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluNurbsSurface
    DB  'gluNurbsSurface',0
end;

procedure _Init_gluOrtho2D;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluOrtho2D
    DB  'gluOrtho2D',0
end;

procedure _Init_gluPartialDisk;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluPartialDisk
    DB  'gluPartialDisk',0
end;

procedure _Init_gluPerspective;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluPerspective
    DB  'gluPerspective',0
end;

procedure _Init_gluPickMatrix;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluPickMatrix
    DB  'gluPickMatrix',0
end;

procedure _Init_gluProject;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluProject
    DB  'gluProject',0
end;

procedure _Init_gluPwlCurve;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluPwlCurve
    DB  'gluPwlCurve',0
end;

procedure _Init_gluQuadricCallback;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluQuadricCallback
    DB  'gluQuadricCallback',0
end;

procedure _Init_gluQuadricDrawStyle;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluQuadricDrawStyle
    DB  'gluQuadricDrawStyle',0
end;

procedure _Init_gluQuadricNormals;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluQuadricNormals
    DB  'gluQuadricNormals',0
end;

procedure _Init_gluQuadricOrientation;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluQuadricOrientation
    DB  'gluQuadricOrientation',0
end;

procedure _Init_gluQuadricTexture;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluQuadricTexture
    DB  'gluQuadricTexture',0
end;

procedure _Init_gluScaleImage;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluScaleImage
    DB  'gluScaleImage',0
end;

procedure _Init_gluSphere;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluSphere
    DB  'gluSphere',0
end;

procedure _Init_gluTessBeginContour;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluTessBeginContour
    DB  'gluTessBeginContour',0
end;

procedure _Init_gluTessBeginPolygon;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluTessBeginPolygon
    DB  'gluTessBeginPolygon',0
end;

procedure _Init_gluTessCallback;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluTessCallback
    DB  'gluTessCallback',0
end;

procedure _Init_gluTessEndContour;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluTessEndContour
    DB  'gluTessEndContour',0
end;

procedure _Init_gluTessEndPolygon;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluTessEndPolygon
    DB  'gluTessEndPolygon',0
end;

procedure _Init_gluTessNormal;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluTessNormal
    DB  'gluTessNormal',0
end;

procedure _Init_gluTessProperty;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluTessProperty
    DB  'gluTessProperty',0
end;

procedure _Init_gluTessVertex;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluTessVertex
    DB  'gluTessVertex',0
end;

procedure _Init_gluUnProject;
asm
    Call GLU_SetupProcAddr;
    DD  offset gluUnProject
    DB  'gluUnProject',0
end;


{procedure PreLoadGLProcAddresses;
var
  VarSetupProcAddr:_TSetupPtocAddr;
begin
  VarSetupProcAddr:=GL_SetupProcAddr;
    VarSetupProcAddr('glAccum',glAccum);
    VarSetupProcAddr('glAlphaFunc',glAlphaFunc);
    VarSetupProcAddr('glAreTexturesResident',glAreTexturesResident);
    VarSetupProcAddr('glArrayElement',glArrayElement);
    VarSetupProcAddr('glBegin',glBegin);
    VarSetupProcAddr('glBindTexture',glBindTexture);
    VarSetupProcAddr('glBitmap',glBitmap);
    VarSetupProcAddr('glBlendFunc',glBlendFunc);
    VarSetupProcAddr('glCallList',glCallList);
    VarSetupProcAddr('glCallLists',glCallLists);
    VarSetupProcAddr('glClear',glClear);
    VarSetupProcAddr('glClearAccum',glClearAccum);
    VarSetupProcAddr('glClearColor',glClearColor);
    VarSetupProcAddr('glClearDepth',glClearDepth);
    VarSetupProcAddr('glClearIndex',glClearIndex);
    VarSetupProcAddr('glClearStencil',glClearStencil);
    VarSetupProcAddr('glClipPlane',glClipPlane);
    VarSetupProcAddr('glColor3b',glColor3b);
    VarSetupProcAddr('glColor3bv',glColor3bv);
    VarSetupProcAddr('glColor3d',glColor3d);
    VarSetupProcAddr('glColor3dv',glColor3dv);
    VarSetupProcAddr('glColor3f',glColor3f);
    VarSetupProcAddr('glColor3fv',glColor3fv);
    VarSetupProcAddr('glColor3i',glColor3i);
    VarSetupProcAddr('glColor3iv',glColor3iv);
    VarSetupProcAddr('glColor3s',glColor3s);
    VarSetupProcAddr('glColor3sv',glColor3sv);
    VarSetupProcAddr('glColor3ub',glColor3ub);
    VarSetupProcAddr('glColor3ubv',glColor3ubv);
    VarSetupProcAddr('glColor3ui',glColor3ui);
    VarSetupProcAddr('glColor3uiv',glColor3uiv);
    VarSetupProcAddr('glColor3us',glColor3us);
    VarSetupProcAddr('glColor3usv',glColor3usv);
    VarSetupProcAddr('glColor4b',glColor4b);
    VarSetupProcAddr('glColor4bv',glColor4bv);
    VarSetupProcAddr('glColor4d',glColor4d);
    VarSetupProcAddr('glColor4dv',glColor4dv);
    VarSetupProcAddr('glColor4f',glColor4f);
    VarSetupProcAddr('glColor4fv',glColor4fv);
    VarSetupProcAddr('glColor4i',glColor4i);
    VarSetupProcAddr('glColor4iv',glColor4iv);
    VarSetupProcAddr('glColor4s',glColor4s);
    VarSetupProcAddr('glColor4sv',glColor4sv);
    VarSetupProcAddr('glColor4ub',glColor4ub);
    VarSetupProcAddr('glColor4ubv',glColor4ubv);
    VarSetupProcAddr('glColor4ui',glColor4ui);
    VarSetupProcAddr('glColor4uiv',glColor4uiv);
    VarSetupProcAddr('glColor4us',glColor4us);
    VarSetupProcAddr('glColor4usv',glColor4usv);
    VarSetupProcAddr('glColorMask',glColorMask);
    VarSetupProcAddr('glColorMaterial',glColorMaterial);
    VarSetupProcAddr('glColorPointer',glColorPointer);
    VarSetupProcAddr('glCopyPixels',glCopyPixels);
    VarSetupProcAddr('glCopyTexImage1D',glCopyTexImage1D);
    VarSetupProcAddr('glCopyTexImage2D',glCopyTexImage2D);
    VarSetupProcAddr('glCopyTexSubImage1D',glCopyTexSubImage1D);
    VarSetupProcAddr('glCopyTexSubImage2D',glCopyTexSubImage2D);
    VarSetupProcAddr('glCullFace',glCullFace);
    VarSetupProcAddr('glDeleteLists',glDeleteLists);
    VarSetupProcAddr('glDeleteTextures',glDeleteTextures);
    VarSetupProcAddr('glDepthFunc',glDepthFunc);
    VarSetupProcAddr('glDepthMask',glDepthMask);
    VarSetupProcAddr('glDepthRange',glDepthRange);
    VarSetupProcAddr('glDisable',glDisable);
    VarSetupProcAddr('glDisableClientState',glDisableClientState);
    VarSetupProcAddr('glDrawArrays',glDrawArrays);
    VarSetupProcAddr('glDrawBuffer',glDrawBuffer);
    VarSetupProcAddr('glDrawElements',glDrawElements);
    VarSetupProcAddr('glDrawPixels',glDrawPixels);
    VarSetupProcAddr('glEdgeFlag',glEdgeFlag);
    VarSetupProcAddr('glEdgeFlagPointer',glEdgeFlagPointer);
    VarSetupProcAddr('glEdgeFlagv',glEdgeFlagv);
    VarSetupProcAddr('glEnable',glEnable);
    VarSetupProcAddr('glEnableClientState',glEnableClientState);
    VarSetupProcAddr('glEnd',glEnd);
    VarSetupProcAddr('glEndList',glEndList);
    VarSetupProcAddr('glEvalCoord1d',glEvalCoord1d);
    VarSetupProcAddr('glEvalCoord1dv',glEvalCoord1dv);
    VarSetupProcAddr('glEvalCoord1f',glEvalCoord1f);
    VarSetupProcAddr('glEvalCoord1fv',glEvalCoord1fv);
    VarSetupProcAddr('glEvalCoord2d',glEvalCoord2d);
    VarSetupProcAddr('glEvalCoord2dv',glEvalCoord2dv);
    VarSetupProcAddr('glEvalCoord2f',glEvalCoord2f);
    VarSetupProcAddr('glEvalCoord2fv',glEvalCoord2fv);
    VarSetupProcAddr('glEvalMesh1',glEvalMesh1);
    VarSetupProcAddr('glEvalMesh2',glEvalMesh2);
    VarSetupProcAddr('glEvalPoint1',glEvalPoint1);
    VarSetupProcAddr('glEvalPoint2',glEvalPoint2);
    VarSetupProcAddr('glFeedbackBuffer',glFeedbackBuffer);
    VarSetupProcAddr('glFinish',glFinish);
    VarSetupProcAddr('glFlush',glFlush);
    VarSetupProcAddr('glFogf',glFogf);
    VarSetupProcAddr('glFogfv',glFogfv);
    VarSetupProcAddr('glFogi',glFogi);
    VarSetupProcAddr('glFogiv',glFogiv);
    VarSetupProcAddr('glFrontFace',glFrontFace);
    VarSetupProcAddr('glFrustum',glFrustum);
    VarSetupProcAddr('glGenLists',glGenLists);
    VarSetupProcAddr('glGenTextures',glGenTextures);
    VarSetupProcAddr('glGetBooleanv',glGetBooleanv);
    VarSetupProcAddr('glGetClipPlane',glGetClipPlane);
    VarSetupProcAddr('glGetDoublev',glGetDoublev);
    VarSetupProcAddr('glGetError',glGetError);
    VarSetupProcAddr('glGetFloatv',glGetFloatv);
    VarSetupProcAddr('glGetIntegerv',glGetIntegerv);
    VarSetupProcAddr('glGetLightfv',glGetLightfv);
    VarSetupProcAddr('glGetLightiv',glGetLightiv);
    VarSetupProcAddr('glGetMapdv',glGetMapdv);
    VarSetupProcAddr('glGetMapfv',glGetMapfv);
    VarSetupProcAddr('glGetMapiv',glGetMapiv);
    VarSetupProcAddr('glGetMaterialfv',glGetMaterialfv);
    VarSetupProcAddr('glGetMaterialiv',glGetMaterialiv);
    VarSetupProcAddr('glGetPixelMapfv',glGetPixelMapfv);
    VarSetupProcAddr('glGetPixelMapuiv',glGetPixelMapuiv);
    VarSetupProcAddr('glGetPixelMapusv',glGetPixelMapusv);
    VarSetupProcAddr('glGetPointerv',glGetPointerv);
    VarSetupProcAddr('glGetPolygonStipple',glGetPolygonStipple);
    VarSetupProcAddr('glGetString',glGetString);
    VarSetupProcAddr('glGetTexEnvfv',glGetTexEnvfv);
    VarSetupProcAddr('glGetTexEnviv',glGetTexEnviv);
    VarSetupProcAddr('glGetTexGendv',glGetTexGendv);
    VarSetupProcAddr('glGetTexGenfv',glGetTexGenfv);
    VarSetupProcAddr('glGetTexGeniv',glGetTexGeniv);
    VarSetupProcAddr('glGetTexImage',glGetTexImage);
    VarSetupProcAddr('glGetTexLevelParameterfv',glGetTexLevelParameterfv);
    VarSetupProcAddr('glGetTexLevelParameteriv',glGetTexLevelParameteriv);
    VarSetupProcAddr('glGetTexParameterfv',glGetTexParameterfv);
    VarSetupProcAddr('glGetTexParameteriv',glGetTexParameteriv);
    VarSetupProcAddr('glHint',glHint);
    VarSetupProcAddr('glIndexMask',glIndexMask);
    VarSetupProcAddr('glIndexPointer',glIndexPointer);
    VarSetupProcAddr('glIndexd',glIndexd);
    VarSetupProcAddr('glIndexdv',glIndexdv);
    VarSetupProcAddr('glIndexf',glIndexf);
    VarSetupProcAddr('glIndexfv',glIndexfv);
    VarSetupProcAddr('glIndexi',glIndexi);
    VarSetupProcAddr('glIndexiv',glIndexiv);
    VarSetupProcAddr('glIndexs',glIndexs);
    VarSetupProcAddr('glIndexsv',glIndexsv);
    VarSetupProcAddr('glIndexub',glIndexub);
    VarSetupProcAddr('glIndexubv',glIndexubv);
    VarSetupProcAddr('glInitNames',glInitNames);
    VarSetupProcAddr('glInterleavedArrays',glInterleavedArrays);
    VarSetupProcAddr('glIsEnabled',glIsEnabled);
    VarSetupProcAddr('glIsList',glIsList);
    VarSetupProcAddr('glIsTexture',glIsTexture);
    VarSetupProcAddr('glLightModelf',glLightModelf);
    VarSetupProcAddr('glLightModelfv',glLightModelfv);
    VarSetupProcAddr('glLightModeli',glLightModeli);
    VarSetupProcAddr('glLightModeliv',glLightModeliv);
    VarSetupProcAddr('glLightf',glLightf);
    VarSetupProcAddr('glLightfv',glLightfv);
    VarSetupProcAddr('glLighti',glLighti);
    VarSetupProcAddr('glLightiv',glLightiv);
    VarSetupProcAddr('glLineStipple',glLineStipple);
    VarSetupProcAddr('glLineWidth',glLineWidth);
    VarSetupProcAddr('glListBase',glListBase);
    VarSetupProcAddr('glLoadIdentity',glLoadIdentity);
    VarSetupProcAddr('glLoadMatrixd',glLoadMatrixd);
    VarSetupProcAddr('glLoadMatrixf',glLoadMatrixf);
    VarSetupProcAddr('glLoadName',glLoadName);
    VarSetupProcAddr('glLogicOp',glLogicOp);
    VarSetupProcAddr('glMap1d',glMap1d);
    VarSetupProcAddr('glMap1f',glMap1f);
    VarSetupProcAddr('glMap2d',glMap2d);
    VarSetupProcAddr('glMap2f',glMap2f);
    VarSetupProcAddr('glMapGrid1d',glMapGrid1d);
    VarSetupProcAddr('glMapGrid1f',glMapGrid1f);
    VarSetupProcAddr('glMapGrid2d',glMapGrid2d);
    VarSetupProcAddr('glMapGrid2f',glMapGrid2f);
    VarSetupProcAddr('glMaterialf',glMaterialf);
    VarSetupProcAddr('glMaterialfv',glMaterialfv);
    VarSetupProcAddr('glMateriali',glMateriali);
    VarSetupProcAddr('glMaterialiv',glMaterialiv);
    VarSetupProcAddr('glMatrixMode',glMatrixMode);
    VarSetupProcAddr('glMultMatrixd',glMultMatrixd);
    VarSetupProcAddr('glMultMatrixf',glMultMatrixf);
    VarSetupProcAddr('glNewList',glNewList);
    VarSetupProcAddr('glNormal3b',glNormal3b);
    VarSetupProcAddr('glNormal3bv',glNormal3bv);
    VarSetupProcAddr('glNormal3d',glNormal3d);
    VarSetupProcAddr('glNormal3dv',glNormal3dv);
    VarSetupProcAddr('glNormal3f',glNormal3f);
    VarSetupProcAddr('glNormal3fv',glNormal3fv);
    VarSetupProcAddr('glNormal3i',glNormal3i);
    VarSetupProcAddr('glNormal3iv',glNormal3iv);
    VarSetupProcAddr('glNormal3s',glNormal3s);
    VarSetupProcAddr('glNormal3sv',glNormal3sv);
    VarSetupProcAddr('glNormalPointer',glNormalPointer);
    VarSetupProcAddr('glOrtho',glOrtho);
    VarSetupProcAddr('glPassThrough',glPassThrough);
    VarSetupProcAddr('glPixelMapfv',glPixelMapfv);
    VarSetupProcAddr('glPixelMapuiv',glPixelMapuiv);
    VarSetupProcAddr('glPixelMapusv',glPixelMapusv);
    VarSetupProcAddr('glPixelStoref',glPixelStoref);
    VarSetupProcAddr('glPixelStorei',glPixelStorei);
    VarSetupProcAddr('glPixelTransferf',glPixelTransferf);
    VarSetupProcAddr('glPixelTransferi',glPixelTransferi);
    VarSetupProcAddr('glPixelZoom',glPixelZoom);
    VarSetupProcAddr('glPointSize',glPointSize);
    VarSetupProcAddr('glPolygonMode',glPolygonMode);
    VarSetupProcAddr('glPolygonOffset',glPolygonOffset);
    VarSetupProcAddr('glPolygonStipple',glPolygonStipple);
    VarSetupProcAddr('glPopAttrib',glPopAttrib);
    VarSetupProcAddr('glPopClientAttrib',glPopClientAttrib);
    VarSetupProcAddr('glPopMatrix',glPopMatrix);
    VarSetupProcAddr('glPopName',glPopName);
    VarSetupProcAddr('glPrioritizeTextures',glPrioritizeTextures);
    VarSetupProcAddr('glPushAttrib',glPushAttrib);
    VarSetupProcAddr('glPushClientAttrib',glPushClientAttrib);
    VarSetupProcAddr('glPushMatrix',glPushMatrix);
    VarSetupProcAddr('glPushName',glPushName);
    VarSetupProcAddr('glRasterPos2d',glRasterPos2d);
    VarSetupProcAddr('glRasterPos2dv',glRasterPos2dv);
    VarSetupProcAddr('glRasterPos2f',glRasterPos2f);
    VarSetupProcAddr('glRasterPos2fv',glRasterPos2fv);
    VarSetupProcAddr('glRasterPos2i',glRasterPos2i);
    VarSetupProcAddr('glRasterPos2iv',glRasterPos2iv);
    VarSetupProcAddr('glRasterPos2s',glRasterPos2s);
    VarSetupProcAddr('glRasterPos2sv',glRasterPos2sv);
    VarSetupProcAddr('glRasterPos3d',glRasterPos3d);
    VarSetupProcAddr('glRasterPos3dv',glRasterPos3dv);
    VarSetupProcAddr('glRasterPos3f',glRasterPos3f);
    VarSetupProcAddr('glRasterPos3fv',glRasterPos3fv);
    VarSetupProcAddr('glRasterPos3i',glRasterPos3i);
    VarSetupProcAddr('glRasterPos3iv',glRasterPos3iv);
    VarSetupProcAddr('glRasterPos3s',glRasterPos3s);
    VarSetupProcAddr('glRasterPos3sv',glRasterPos3sv);
    VarSetupProcAddr('glRasterPos4d',glRasterPos4d);
    VarSetupProcAddr('glRasterPos4dv',glRasterPos4dv);
    VarSetupProcAddr('glRasterPos4f',glRasterPos4f);
    VarSetupProcAddr('glRasterPos4fv',glRasterPos4fv);
    VarSetupProcAddr('glRasterPos4i',glRasterPos4i);
    VarSetupProcAddr('glRasterPos4iv',glRasterPos4iv);
    VarSetupProcAddr('glRasterPos4s',glRasterPos4s);
    VarSetupProcAddr('glRasterPos4sv',glRasterPos4sv);
    VarSetupProcAddr('glReadBuffer',glReadBuffer);
    VarSetupProcAddr('glReadPixels',glReadPixels);
    VarSetupProcAddr('glRectd',glRectd);
    VarSetupProcAddr('glRectdv',glRectdv);
    VarSetupProcAddr('glRectf',glRectf);
    VarSetupProcAddr('glRectfv',glRectfv);
    VarSetupProcAddr('glRecti',glRecti);
    VarSetupProcAddr('glRectiv',glRectiv);
    VarSetupProcAddr('glRects',glRects);
    VarSetupProcAddr('glRectsv',glRectsv);
    VarSetupProcAddr('glRenderMode',glRenderMode);
    VarSetupProcAddr('glRotated',glRotated);
    VarSetupProcAddr('glRotatef',glRotatef);
    VarSetupProcAddr('glScaled',glScaled);
    VarSetupProcAddr('glScalef',glScalef);
    VarSetupProcAddr('glScissor',glScissor);
    VarSetupProcAddr('glSelectBuffer',glSelectBuffer);
    VarSetupProcAddr('glShadeModel',glShadeModel);
    VarSetupProcAddr('glStencilFunc',glStencilFunc);
    VarSetupProcAddr('glStencilMask',glStencilMask);
    VarSetupProcAddr('glStencilOp',glStencilOp);
    VarSetupProcAddr('glTexCoord1d', glTexCoord1d);
    VarSetupProcAddr('glTexCoord1dv', glTexCoord1dv);
    VarSetupProcAddr('glTexCoord1f', glTexCoord1f);
    VarSetupProcAddr('glTexCoord1fv', glTexCoord1fv);
    VarSetupProcAddr('glTexCoord1i', glTexCoord1i);
    VarSetupProcAddr('glTexCoord1iv', glTexCoord1iv);
    VarSetupProcAddr('glTexCoord1s', glTexCoord1s);
    VarSetupProcAddr('glTexCoord1sv', glTexCoord1sv);
    VarSetupProcAddr('glTexCoord2d', glTexCoord2d);
    VarSetupProcAddr('glTexCoord2dv', glTexCoord2dv);
    VarSetupProcAddr('glTexCoord2f', glTexCoord2f);
    VarSetupProcAddr('glTexCoord2fv', glTexCoord2fv);
    VarSetupProcAddr('glTexCoord2i', glTexCoord2i);
    VarSetupProcAddr('glTexCoord2iv', glTexCoord2iv);
    VarSetupProcAddr('glTexCoord2s', glTexCoord2s);
    VarSetupProcAddr('glTexCoord2sv', glTexCoord2sv);
    VarSetupProcAddr('glTexCoord3d', glTexCoord3d);
    VarSetupProcAddr('glTexCoord3dv', glTexCoord3dv);
    VarSetupProcAddr('glTexCoord3f', glTexCoord3f);
    VarSetupProcAddr('glTexCoord3fv', glTexCoord3fv);
    VarSetupProcAddr('glTexCoord3i', glTexCoord3i);
    VarSetupProcAddr('glTexCoord3iv', glTexCoord3iv);
    VarSetupProcAddr('glTexCoord3s', glTexCoord3s);
    VarSetupProcAddr('glTexCoord3sv', glTexCoord3sv);
    VarSetupProcAddr('glTexCoord4d', glTexCoord4d);
    VarSetupProcAddr('glTexCoord4dv', glTexCoord4dv);
    VarSetupProcAddr('glTexCoord4f', glTexCoord4f);
    VarSetupProcAddr('glTexCoord4fv', glTexCoord4fv);
    VarSetupProcAddr('glTexCoord4i', glTexCoord4i);
    VarSetupProcAddr('glTexCoord4iv', glTexCoord4iv);
    VarSetupProcAddr('glTexCoord4s', glTexCoord4s);
    VarSetupProcAddr('glTexCoord4sv', glTexCoord4sv);
    VarSetupProcAddr('glTexCoordPointer', glTexCoordPointer);
    VarSetupProcAddr('glTexEnvf', glTexEnvf);
    VarSetupProcAddr('glTexEnvfv', glTexEnvfv);
    VarSetupProcAddr('glTexEnvi', glTexEnvi);
    VarSetupProcAddr('glTexEnviv', glTexEnviv);
    VarSetupProcAddr('glTexGend', glTexGend);
    VarSetupProcAddr('glTexGendv', glTexGendv);
    VarSetupProcAddr('glTexGenf', glTexGenf);
    VarSetupProcAddr('glTexGenfv', glTexGenfv);
    VarSetupProcAddr('glTexGeni', glTexGeni);
    VarSetupProcAddr('glTexGeniv', glTexGeniv);
    VarSetupProcAddr('glTexImage1D', glTexImage1D);
    VarSetupProcAddr('glTexImage2D', glTexImage2D);
    VarSetupProcAddr('glTexParameterf', glTexParameterf);
    VarSetupProcAddr('glTexParameterfv', glTexParameterfv);
    VarSetupProcAddr('glTexParameteri', glTexParameteri);
    VarSetupProcAddr('glTexParameteriv', glTexParameteriv);
    VarSetupProcAddr('glTexSubImage1D', glTexSubImage1D);
    VarSetupProcAddr('glTexSubImage2D', glTexSubImage2D);
    VarSetupProcAddr('glTranslated', glTranslated);
    VarSetupProcAddr('glTranslatef', glTranslatef);
    VarSetupProcAddr('glVertex2d', glVertex2d);
    VarSetupProcAddr('glVertex2dv', glVertex2dv);
    VarSetupProcAddr('glVertex2f', glVertex2f);
    VarSetupProcAddr('glVertex2fv', glVertex2fv);
    VarSetupProcAddr('glVertex2i', glVertex2i);
    VarSetupProcAddr('glVertex2iv', glVertex2iv);
    VarSetupProcAddr('glVertex2s', glVertex2s);
    VarSetupProcAddr('glVertex2sv', glVertex2sv);
    VarSetupProcAddr('glVertex3d', glVertex3d);
    VarSetupProcAddr('glVertex3dv', glVertex3dv);
    VarSetupProcAddr('glVertex3f', glVertex3f);
    VarSetupProcAddr('glVertex3fv', glVertex3fv);
    VarSetupProcAddr('glVertex3i', glVertex3i);
    VarSetupProcAddr('glVertex3iv', glVertex3iv);
    VarSetupProcAddr('glVertex3s', glVertex3s);
    VarSetupProcAddr('glVertex3sv', glVertex3sv);
    VarSetupProcAddr('glVertex4d', glVertex4d);
    VarSetupProcAddr('glVertex4dv', glVertex4dv);
    VarSetupProcAddr('glVertex4f', glVertex4f);
    VarSetupProcAddr('glVertex4fv', glVertex4fv);
    VarSetupProcAddr('glVertex4i', glVertex4i);
    VarSetupProcAddr('glVertex4iv', glVertex4iv);
    VarSetupProcAddr('glVertex4s', glVertex4s);
    VarSetupProcAddr('glVertex4sv', glVertex4sv);
    VarSetupProcAddr('glVertexPointer', glVertexPointer);
    VarSetupProcAddr('glViewport', glViewport);

    // window support routines

    VarSetupProcAddr('wglGetProcAddress', wglGetProcAddress);
    VarSetupProcAddr('wglCopyContext', wglCopyContext);
    VarSetupProcAddr('wglCreateContext', wglCreateContext);
    VarSetupProcAddr('wglCreateLayerContext', wglCreateLayerContext);
    VarSetupProcAddr('wglDeleteContext', wglDeleteContext);
    VarSetupProcAddr('wglDescribeLayerPlane', wglDescribeLayerPlane);
    VarSetupProcAddr('wglGetCurrentContext', wglGetCurrentContext);
    VarSetupProcAddr('wglGetCurrentDC', wglGetCurrentDC);
    VarSetupProcAddr('wglGetLayerPaletteEntries', wglGetLayerPaletteEntries);
    VarSetupProcAddr('wglMakeCurrent', wglMakeCurrent);
    VarSetupProcAddr('wglRealizeLayerPalette', wglRealizeLayerPalette);
    VarSetupProcAddr('wglSetLayerPaletteEntries', wglSetLayerPaletteEntries);
    VarSetupProcAddr('wglShareLists', wglShareLists);
    VarSetupProcAddr('wglSwapLayerBuffers', wglSwapLayerBuffers);
    VarSetupProcAddr('wglSwapMultipleBuffers', wglSwapMultipleBuffers);
    VarSetupProcAddr('wglUseFontBitmapsA', wglUseFontBitmapsA);
    VarSetupProcAddr('wglUseFontOutlinesA', wglUseFontOutlinesA);
    VarSetupProcAddr('wglUseFontBitmapsW', wglUseFontBitmapsW);
    VarSetupProcAddr('wglUseFontOutlinesW', wglUseFontOutlinesW);
    VarSetupProcAddr('wglUseFontBitmaps', wglUseFontBitmaps);
    VarSetupProcAddr('wglUseFontOutlines', wglUseFontOutlines);

    // GL 1.2
    VarSetupProcAddr('glDrawRangeElements', glDrawRangeElements);
    VarSetupProcAddr('glTexImage3D', glTexImage3D);
    // GL 1.2 ARB imaging
    VarSetupProcAddr('glBlendColor', glBlendColor);
    VarSetupProcAddr('glBlendEquation', glBlendEquation);
    VarSetupProcAddr('glColorSubTable', glColorSubTable);
    VarSetupProcAddr('glCopyColorSubTable', glCopyColorSubTable);
    VarSetupProcAddr('glColorTable', glColorTable);
    VarSetupProcAddr('glCopyColorTable', glCopyColorTable);
    VarSetupProcAddr('glColorTableParameteriv', glColorTableParameteriv);
    VarSetupProcAddr('glColorTableParameterfv', glColorTableParameterfv);
    VarSetupProcAddr('glGetColorTable', glGetColorTable);
    VarSetupProcAddr('glGetColorTableParameteriv', glGetColorTableParameteriv);
    VarSetupProcAddr('glGetColorTableParameterfv', glGetColorTableParameterfv);
    VarSetupProcAddr('glConvolutionFilter1D', glConvolutionFilter1D);
    VarSetupProcAddr('glConvolutionFilter2D', glConvolutionFilter2D);
    VarSetupProcAddr('glCopyConvolutionFilter1D', glCopyConvolutionFilter1D);
    VarSetupProcAddr('glCopyConvolutionFilter2D', glCopyConvolutionFilter2D);
    VarSetupProcAddr('glGetConvolutionFilter', glGetConvolutionFilter);
    VarSetupProcAddr('glSeparableFilter2D', glSeparableFilter2D);
    VarSetupProcAddr('glGetSeparableFilter', glGetSeparableFilter);
    VarSetupProcAddr('glConvolutionParameteri', glConvolutionParameteri);
    VarSetupProcAddr('glConvolutionParameteriv', glConvolutionParameteriv);
    VarSetupProcAddr('glConvolutionParameterf', glConvolutionParameterf);
    VarSetupProcAddr('glConvolutionParameterfv', glConvolutionParameterfv);
    VarSetupProcAddr('glGetConvolutionParameteriv', glGetConvolutionParameteriv);
    VarSetupProcAddr('glGetConvolutionParameterfv', glGetConvolutionParameterfv);
    VarSetupProcAddr('glHistogram', glHistogram);
    VarSetupProcAddr('glResetHistogram', glResetHistogram);
    VarSetupProcAddr('glGetHistogram', glGetHistogram);
    VarSetupProcAddr('glGetHistogramParameteriv', glGetHistogramParameteriv);
    VarSetupProcAddr('glGetHistogramParameterfv', glGetHistogramParameterfv);
    VarSetupProcAddr('glMinmax', glMinmax);
    VarSetupProcAddr('glResetMinmax', glResetMinmax);
    VarSetupProcAddr('glGetMinmax', glGetMinmax);
    VarSetupProcAddr('glGetMinmaxParameteriv', glGetMinmaxParameteriv);
    VarSetupProcAddr('glGetMinmaxParameterfv', glGetMinmaxParameterfv);

  VarSetupProcAddr:=GLU_SetupProcAddr;
    VarSetupProcAddr('gluBeginCurve', gluBeginCurve);
    VarSetupProcAddr('gluBeginPolygon', gluBeginPolygon);
    VarSetupProcAddr('gluBeginSurface', gluBeginSurface);
    VarSetupProcAddr('gluBeginTrim', gluBeginTrim);
    VarSetupProcAddr('gluBuild1DMipmaps', gluBuild1DMipmaps);
    VarSetupProcAddr('gluBuild2DMipmaps', gluBuild2DMipmaps);
    VarSetupProcAddr('gluCylinder', gluCylinder);
    VarSetupProcAddr('gluDeleteNurbsRenderer', gluDeleteNurbsRenderer);
    VarSetupProcAddr('gluDeleteQuadric', gluDeleteQuadric);
    VarSetupProcAddr('gluDeleteTess', gluDeleteTess);
    VarSetupProcAddr('gluDisk', gluDisk);
    VarSetupProcAddr('gluEndCurve', gluEndCurve);
    VarSetupProcAddr('gluEndPolygon', gluEndPolygon);
    VarSetupProcAddr('gluEndSurface', gluEndSurface);
    VarSetupProcAddr('gluEndTrim', gluEndTrim);
    VarSetupProcAddr('gluErrorString', gluErrorString);
    VarSetupProcAddr('gluGetNurbsProperty', gluGetNurbsProperty);
    VarSetupProcAddr('gluGetString', gluGetString);
    VarSetupProcAddr('gluGetTessProperty', gluGetTessProperty);
    VarSetupProcAddr('gluLoadSamplingMatrices', gluLoadSamplingMatrices);
    VarSetupProcAddr('gluLookAt', gluLookAt);
    VarSetupProcAddr('gluNewNurbsRenderer', gluNewNurbsRenderer);
    VarSetupProcAddr('gluNewQuadric', gluNewQuadric);
    VarSetupProcAddr('gluNewTess', gluNewTess);
    VarSetupProcAddr('gluNextContour', gluNextContour);
    VarSetupProcAddr('gluNurbsCallback', gluNurbsCallback);
    VarSetupProcAddr('gluNurbsCurve', gluNurbsCurve);
    VarSetupProcAddr('gluNurbsProperty', gluNurbsProperty);
    VarSetupProcAddr('gluNurbsSurface', gluNurbsSurface);
    VarSetupProcAddr('gluOrtho2D', gluOrtho2D);
    VarSetupProcAddr('gluPartialDisk', gluPartialDisk);
    VarSetupProcAddr('gluPerspective', gluPerspective);
    VarSetupProcAddr('gluPickMatrix', gluPickMatrix);
    VarSetupProcAddr('gluProject', gluProject);
    VarSetupProcAddr('gluPwlCurve', gluPwlCurve);
    VarSetupProcAddr('gluQuadricCallback', gluQuadricCallback);
    VarSetupProcAddr('gluQuadricDrawStyle', gluQuadricDrawStyle);
    VarSetupProcAddr('gluQuadricNormals', gluQuadricNormals);
    VarSetupProcAddr('gluQuadricOrientation', gluQuadricOrientation);
    VarSetupProcAddr('gluQuadricTexture', gluQuadricTexture);
    VarSetupProcAddr('gluScaleImage', gluScaleImage);
    VarSetupProcAddr('gluSphere', gluSphere);
    VarSetupProcAddr('gluTessBeginContour', gluTessBeginContour);
    VarSetupProcAddr('gluTessBeginPolygon', gluTessBeginPolygon);
    VarSetupProcAddr('gluTessCallback', gluTessCallback);
    VarSetupProcAddr('gluTessEndContour', gluTessEndContour);
    VarSetupProcAddr('gluTessEndPolygon', gluTessEndPolygon);
    VarSetupProcAddr('gluTessNormal', gluTessNormal);
    VarSetupProcAddr('gluTessProperty', gluTessProperty);
    VarSetupProcAddr('gluTessVertex', gluTessVertex);
    VarSetupProcAddr('gluUnProject', gluUnProject);

end;}

//----------------------------------------------------------------------------------------------------------------------

procedure ReadExtensions;
// to be used in an active rendering context only!
begin
  // GL extensions
  glArrayElementArrayEXT := wglGetProcAddress('glArrayElementArrayEXT');
  glColorTableEXT := wglGetProcAddress('glColorTableEXT');
  glColorSubTableEXT := wglGetProcAddress('glColorSubTableEXT');
  glGetColorTableEXT := wglGetProcAddress('glGetColorTableEXT');
  glGetColorTablePameterivEXT := wglGetProcAddress('glGetColorTablePameterivEXT');
  glGetColorTablePameterfvEXT := wglGetProcAddress('glGetColorTablePameterfvEXT');
  glLockArraysEXT := wglGetProcAddress('glLockArraysEXT');
  glUnlockArraysEXT := wglGetProcAddress('glUnlockArraysEXT');
  glCopyTexImage1DEXT := wglGetProcAddress('glCopyTexImage1DEXT');
  glCopyTexSubImage1DEXT := wglGetProcAddress('glCopyTexSubImage1DEXT');
  glCopyTexImage2DEXT := wglGetProcAddress('glCopyTexImage2DEXT');
  glCopyTexSubImage2DEXT := wglGetProcAddress('glCopyTexSubImage2DEXT');
  glCopyTexSubImage3DEXT := wglGetProcAddress('glCopyTexSubImage3DEXT');
  glIndexFuncEXT := wglGetProcAddress('glIndexFuncEXT');
  glIndexMaterialEXT := wglGetProcAddress('glIndexMaterialEXT');
  glPolygonOffsetEXT := wglGetProcAddress('glPolygonOffsetEXT');
  glTexSubImage1dEXT := wglGetProcAddress('glTexSubImage1DEXT');
  glTexSubImage2dEXT := wglGetProcAddress('glTexSubImage2DEXT');
  glTexSubImage3dEXT := wglGetProcAddress('glTexSubImage3DEXT');
  glGenTexturesEXT := wglGetProcAddress('glGenTexturesEXT');
  glDeleteTexturesEXT := wglGetProcAddress('glDeleteTexturesEXT');
  glBindTextureEXT := wglGetProcAddress('glBindTextureEXT');
  glPrioritizeTexturesEXT := wglGetProcAddress('glPrioritizeTexturesEXT');
  glAreTexturesResidentEXT := wglGetProcAddress('glAreTexturesResidentEXT');
  glIsTextureEXT := wglGetProcAddress('glIsTextureEXT');

  // EXT_vertex_array
  glArrayElementEXT := wglGetProcAddress('glArrayElementEXT');
  glColorPointerEXT := wglGetProcAddress('glColorPointerEXT');
  glDrawArraysEXT := wglGetProcAddress('glDrawArraysEXT');
  glEdgeFlagPointerEXT := wglGetProcAddress('glEdgeFlagPointerEXT');
  glGetPointervEXT := wglGetProcAddress('glGetPointervEXT');
  glIndexPointerEXT := wglGetProcAddress('glIndexPointerEXT');
  glNormalPointerEXT := wglGetProcAddress('glNormalPointerEXT');
  glTexCoordPointerEXT := wglGetProcAddress('glTexCoordPointerEXT');
  glVertexPointerEXT := wglGetProcAddress('glVertexPointerEXT');

  // ARB_multitexture
  glMultiTexCoord1dARB := wglGetProcAddress('glMultiTexCoord1dARB');
  glMultiTexCoord1dVARB := wglGetProcAddress('glMultiTexCoord1dVARB');
  glMultiTexCoord1fARBP := wglGetProcAddress('glMultiTexCoord1fARBP');
  glMultiTexCoord1fVARB := wglGetProcAddress('glMultiTexCoord1fVARB');
  glMultiTexCoord1iARB := wglGetProcAddress('glMultiTexCoord1iARB');
  glMultiTexCoord1iVARB := wglGetProcAddress('glMultiTexCoord1iVARB');
  glMultiTexCoord1sARBP := wglGetProcAddress('glMultiTexCoord1sARBP');
  glMultiTexCoord1sVARB := wglGetProcAddress('glMultiTexCoord1sVARB');
  glMultiTexCoord2dARB := wglGetProcAddress('glMultiTexCoord2dARB');
  glMultiTexCoord2dvARB := wglGetProcAddress('glMultiTexCoord2dvARB');
  glMultiTexCoord2fARB := wglGetProcAddress('glMultiTexCoord2fARB');
  glMultiTexCoord2fvARB := wglGetProcAddress('glMultiTexCoord2fvARB');
  glMultiTexCoord2iARB := wglGetProcAddress('glMultiTexCoord2iARB');
  glMultiTexCoord2ivARB := wglGetProcAddress('glMultiTexCoord2ivARB');
  glMultiTexCoord2sARB := wglGetProcAddress('glMultiTexCoord2sARB');
  glMultiTexCoord2svARB := wglGetProcAddress('glMultiTexCoord2svARB');
  glMultiTexCoord3dARB := wglGetProcAddress('glMultiTexCoord3dARB');
  glMultiTexCoord3dvARB := wglGetProcAddress('glMultiTexCoord3dvARB');
  glMultiTexCoord3fARB := wglGetProcAddress('glMultiTexCoord3fARB');
  glMultiTexCoord3fvARB := wglGetProcAddress('glMultiTexCoord3fvARB');
  glMultiTexCoord3iARB := wglGetProcAddress('glMultiTexCoord3iARB');
  glMultiTexCoord3ivARB := wglGetProcAddress('glMultiTexCoord3ivARB');
  glMultiTexCoord3sARB := wglGetProcAddress('glMultiTexCoord3sARB');
  glMultiTexCoord3svARB := wglGetProcAddress('glMultiTexCoord3svARB');
  glMultiTexCoord4dARB := wglGetProcAddress('glMultiTexCoord4dARB');
  glMultiTexCoord4dvARB := wglGetProcAddress('glMultiTexCoord4dvARB');
  glMultiTexCoord4fARB := wglGetProcAddress('glMultiTexCoord4fARB');
  glMultiTexCoord4fvARB := wglGetProcAddress('glMultiTexCoord4fvARB');
  glMultiTexCoord4iARB := wglGetProcAddress('glMultiTexCoord4iARB');
  glMultiTexCoord4ivARB := wglGetProcAddress('glMultiTexCoord4ivARB');
  glMultiTexCoord4sARB := wglGetProcAddress('glMultiTexCoord4sARB');
  glMultiTexCoord4svARB := wglGetProcAddress('glMultiTexCoord4svARB');
  glActiveTextureARB := wglGetProcAddress('glActiveTextureARB');
  glClientActiveTextureARB := wglGetProcAddress('glClientActiveTextureARB');

  // EXT_compiled_vertex_array
  glLockArrayEXT := wglGetProcAddress('glLockArrayEXT');
  glUnlockArrayEXT := wglGetProcAddress('glUnlockArrayEXT');

  // EXT_cull_vertex
  glCullParameterdvEXT := wglGetProcAddress('glCullParameterdvEXT');
  glCullParameterfvEXT := wglGetProcAddress('glCullParameterfvEXT');

  // WIN_swap_hint
  glAddSwapHintRectWIN := wglGetProcAddress('glAddSwapHintRectWIN');

  // EXT_point_parameter
  glPointParameterfEXT := wglGetProcAddress('glPointParameterfEXT');
  glPointParameterfvEXT := wglGetProcAddress('glPointParameterfvEXT');

  // GL_ARB_transpose_matrix
  glLoadTransposeMatrixfARB := wglGetProcAddress('glLoadTransposeMatrixfARB');
  glLoadTransposeMatrixdARB := wglGetProcAddress('glLoadTransposeMatrixdARB');
  glMultTransposeMatrixfARB := wglGetProcAddress('glMultTransposeMatrixfARB');
  glMultTransposeMatrixdARB := wglGetProcAddress('glMultTransposeMatrixdARB');

  glSampleCoverageARB := wglGetProcAddress('glSampleCoverageARB');
  glSamplePassARB := wglGetProcAddress('glSamplePassARB');

  // GL_ARB_multisample
  glCompressedTexImage3DARB := wglGetProcAddress('glCompressedTexImage3DARB');
  glCompressedTexImage2DARB := wglGetProcAddress('glCompressedTexImage2DARB');
  glCompressedTexImage1DARB := wglGetProcAddress('glCompressedTexImage1DARB');
  glCompressedTexSubImage3DARB := wglGetProcAddress('glCompressedTexSubImage3DARB');
  glCompressedTexSubImage2DARB := wglGetProcAddress('glCompressedTexSubImage2DARB');
  glCompressedTexSubImage1DARB := wglGetProcAddress('glCompressedTexSubImage1DARB');
  glGetCompressedTexImageARB := wglGetProcAddress('glGetCompressedTexImageARB');

  // GL_EXT_blend_color
  glBlendColorEXT := wglGetProcAddress('glBlendColorEXT');

  // GL_EXT_texture3D
  glTexImage3DEXT := wglGetProcAddress('glTexImage3DEXT');

  // GL_SGIS_texture_filter4
  glGetTexFilterFuncSGIS := wglGetProcAddress('glGetTexFilterFuncSGIS');
  glTexFilterFuncSGIS := wglGetProcAddress('glTexFilterFuncSGIS');

  // GL_EXT_histogram
  glGetHistogramEXT := wglGetProcAddress('glGetHistogramEXT');
  glGetHistogramParameterfvEXT := wglGetProcAddress('glGetHistogramParameterfvEXT');
  glGetHistogramParameterivEXT := wglGetProcAddress('glGetHistogramParameterivEXT');
  glGetMinmaxEXT := wglGetProcAddress('glGetMinmaxEXT');
  glGetMinmaxParameterfvEXT := wglGetProcAddress('glGetMinmaxParameterfvEXT');
  glGetMinmaxParameterivEXT := wglGetProcAddress('glGetMinmaxParameterivEXT');
  glHistogramEXT := wglGetProcAddress('glHistogramEXT');
  glMinmaxEXT := wglGetProcAddress('glMinmaxEXT');
  glResetHistogramEXT := wglGetProcAddress('glResetHistogramEXT');
  glResetMinmaxEXT := wglGetProcAddress('glResetMinmaxEXT');

  // GL_EXT_convolution
  glConvolutionFilter1DEXT := wglGetProcAddress('glConvolutionFilter1DEXT');
  glConvolutionFilter2DEXT := wglGetProcAddress('glConvolutionFilter2DEXT');
  glConvolutionParameterfEXT := wglGetProcAddress('glConvolutionParameterfEXT');
  glConvolutionParameterfvEXT := wglGetProcAddress('glConvolutionParameterfvEXT');
  glConvolutionParameteriEXT := wglGetProcAddress('glConvolutionParameteriEXT');
  glConvolutionParameterivEXT := wglGetProcAddress('glConvolutionParameterivEXT');
  glCopyConvolutionFilter1DEXT := wglGetProcAddress('glCopyConvolutionFilter1DEXT');
  glCopyConvolutionFilter2DEXT := wglGetProcAddress('glCopyConvolutionFilter2DEXT');
  glGetConvolutionFilterEXT := wglGetProcAddress('glGetConvolutionFilterEXT');
  glGetConvolutionParameterfvEXT := wglGetProcAddress('glGetConvolutionParameterfvEXT');
  glGetConvolutionParameterivEXT := wglGetProcAddress('glGetConvolutionParameterivEXT');
  glGetSeparableFilterEXT := wglGetProcAddress('glGetSeparableFilterEXT');
  glSeparableFilter2DEXT := wglGetProcAddress('glSeparableFilter2DEXT');

  // GL_SGI_color_table
  glColorTableSGI := wglGetProcAddress('glColorTableSGI');
  glColorTableParameterfvSGI := wglGetProcAddress('glColorTableParameterfvSGI');
  glColorTableParameterivSGI := wglGetProcAddress('glColorTableParameterivSGI');
  glCopyColorTableSGI := wglGetProcAddress('glCopyColorTableSGI');
  glGetColorTableSGI := wglGetProcAddress('glGetColorTableSGI');
  glGetColorTableParameterfvSGI := wglGetProcAddress('glGetColorTableParameterfvSGI');
  glGetColorTableParameterivSGI := wglGetProcAddress('glGetColorTableParameterivSGI');

  // GL_SGIX_pixel_texture
  glPixelTexGenSGIX := wglGetProcAddress('glPixelTexGenSGIX');

  // GL_SGIS_pixel_texture
  glPixelTexGenParameteriSGIS := wglGetProcAddress('glPixelTexGenParameteriSGIS');
  glPixelTexGenParameterivSGIS := wglGetProcAddress('glPixelTexGenParameterivSGIS');
  glPixelTexGenParameterfSGIS := wglGetProcAddress('glPixelTexGenParameterfSGIS');
  glPixelTexGenParameterfvSGIS := wglGetProcAddress('glPixelTexGenParameterfvSGIS');
  glGetPixelTexGenParameterivSGIS := wglGetProcAddress('glGetPixelTexGenParameterivSGIS');
  glGetPixelTexGenParameterfvSGIS := wglGetProcAddress('glGetPixelTexGenParameterfvSGIS');

  // GL_SGIS_texture4D
  glTexImage4DSGIS := wglGetProcAddress('glTexImage4DSGIS');
  glTexSubImage4DSGIS := wglGetProcAddress('glTexSubImage4DSGIS');

  // GL_SGIS_detail_texture
  glDetailTexFuncSGIS := wglGetProcAddress('glDetailTexFuncSGIS');
  glGetDetailTexFuncSGIS := wglGetProcAddress('glGetDetailTexFuncSGIS');

  // GL_SGIS_sharpen_texture
  glSharpenTexFuncSGIS := wglGetProcAddress('glSharpenTexFuncSGIS');
  glGetSharpenTexFuncSGIS := wglGetProcAddress('glGetSharpenTexFuncSGIS');

  // GL_SGIS_multisample
  glSampleMaskSGIS := wglGetProcAddress('glSampleMaskSGIS');
  glSamplePatternSGIS := wglGetProcAddress('glSamplePatternSGIS');

  // GL_EXT_blend_minmax
  glBlendEquationEXT := wglGetProcAddress('glBlendEquationEXT');

  // GL_SGIX_sprite
  glSpriteParameterfSGIX := wglGetProcAddress('glSpriteParameterfSGIX');
  glSpriteParameterfvSGIX := wglGetProcAddress('glSpriteParameterfvSGIX');
  glSpriteParameteriSGIX := wglGetProcAddress('glSpriteParameteriSGIX');
  glSpriteParameterivSGIX := wglGetProcAddress('glSpriteParameterivSGIX');

  // GL_EXT_point_parameters
  glPointParameterfSGIS := wglGetProcAddress('glPointParameterfSGIS');
  glPointParameterfvSGIS := wglGetProcAddress('glPointParameterfvSGIS');

  // GL_SGIX_instruments
  glGetInstrumentsSGIX := wglGetProcAddress('glGetInstrumentsSGIX');
  glInstrumentsBufferSGIX := wglGetProcAddress('glInstrumentsBufferSGIX');
  glPollInstrumentsSGIX := wglGetProcAddress('glPollInstrumentsSGIX');
  glReadInstrumentsSGIX := wglGetProcAddress('glReadInstrumentsSGIX');
  glStartInstrumentsSGIX := wglGetProcAddress('glStartInstrumentsSGIX');
  glStopInstrumentsSGIX := wglGetProcAddress('glStopInstrumentsSGIX');

  // GL_SGIX_framezoom
  glFrameZoomSGIX := wglGetProcAddress('glFrameZoomSGIX');

  // GL_SGIX_tag_sample_buffer
  glTagSampleBufferSGIX := wglGetProcAddress('glTagSampleBufferSGIX');

  // GL_SGIX_polynomial_ffd
  glDeformationMap3dSGIX := wglGetProcAddress('glDeformationMap3dSGIX');
  glDeformationMap3fSGIX := wglGetProcAddress('glDeformationMap3fSGIX');
  glDeformSGIX := wglGetProcAddress('glDeformSGIX');
  glLoadIdentityDeformationMapSGIX := wglGetProcAddress('glLoadIdentityDeformationMapSGIX');

  // GL_SGIX_reference_plane
  glReferencePlaneSGIX := wglGetProcAddress('glReferencePlaneSGIX');

  // GL_SGIX_flush_raster
  glFlushRasterSGIX := wglGetProcAddress('glFlushRasterSGIX');

  // GL_SGIS_fog_function
  glFogFuncSGIS := wglGetProcAddress('glFogFuncSGIS');
  glGetFogFuncSGIS := wglGetProcAddress('glGetFogFuncSGIS');

  // GL_HP_image_transform
  glImageTransformParameteriHP := wglGetProcAddress('glImageTransformParameteriHP');
  glImageTransformParameterfHP := wglGetProcAddress('glImageTransformParameterfHP');
  glImageTransformParameterivHP := wglGetProcAddress('glImageTransformParameterivHP');
  glImageTransformParameterfvHP := wglGetProcAddress('glImageTransformParameterfvHP');
  glGetImageTransformParameterivHP := wglGetProcAddress('glGetImageTransformParameterivHP');
  glGetImageTransformParameterfvHP := wglGetProcAddress('glGetImageTransformParameterfvHP');

  // GL_EXT_color_subtable
  glCopyColorSubTableEXT := wglGetProcAddress('glCopyColorSubTableEXT');

  // GL_PGI_misc_hints
  glHintPGI := wglGetProcAddress('glHintPGI');

  // GL_EXT_paletted_texture
  glGetColorTableParameterivEXT := wglGetProcAddress('glGetColorTableParameterivEXT');
  glGetColorTableParameterfvEXT := wglGetProcAddress('glGetColorTableParameterfvEXT');

  // GL_SGIX_list_priority
  glGetListParameterfvSGIX := wglGetProcAddress('glGetListParameterfvSGIX');
  glGetListParameterivSGIX := wglGetProcAddress('glGetListParameterivSGIX');
  glListParameterfSGIX := wglGetProcAddress('glListParameterfSGIX');
  glListParameterfvSGIX := wglGetProcAddress('glListParameterfvSGIX');
  glListParameteriSGIX := wglGetProcAddress('glListParameteriSGIX');
  glListParameterivSGIX := wglGetProcAddress('glListParameterivSGIX');

  // GL_SGIX_fragment_lighting
  glFragmentColorMaterialSGIX := wglGetProcAddress('glFragmentColorMaterialSGIX');
  glFragmentLightfSGIX := wglGetProcAddress('glFragmentLightfSGIX');
  glFragmentLightfvSGIX := wglGetProcAddress('glFragmentLightfvSGIX');
  glFragmentLightiSGIX := wglGetProcAddress('glFragmentLightiSGIX');
  glFragmentLightivSGIX := wglGetProcAddress('glFragmentLightivSGIX');
  glFragmentLightModelfSGIX := wglGetProcAddress('glFragmentLightModelfSGIX');
  glFragmentLightModelfvSGIX := wglGetProcAddress('glFragmentLightModelfvSGIX');
  glFragmentLightModeliSGIX := wglGetProcAddress('glFragmentLightModeliSGIX');
  glFragmentLightModelivSGIX := wglGetProcAddress('glFragmentLightModelivSGIX');
  glFragmentMaterialfSGIX := wglGetProcAddress('glFragmentMaterialfSGIX');
  glFragmentMaterialfvSGIX := wglGetProcAddress('glFragmentMaterialfvSGIX');
  glFragmentMaterialiSGIX := wglGetProcAddress('glFragmentMaterialiSGIX');
  glFragmentMaterialivSGIX := wglGetProcAddress('glFragmentMaterialivSGIX');
  glGetFragmentLightfvSGIX := wglGetProcAddress('glGetFragmentLightfvSGIX');
  glGetFragmentLightivSGIX := wglGetProcAddress('glGetFragmentLightivSGIX');
  glGetFragmentMaterialfvSGIX := wglGetProcAddress('glGetFragmentMaterialfvSGIX');
  glGetFragmentMaterialivSGIX := wglGetProcAddress('glGetFragmentMaterialivSGIX');
  glLightEnviSGIX := wglGetProcAddress('glLightEnviSGIX');

  // GL_EXT_draw_range_elements
  glDrawRangeElementsEXT := wglGetProcAddress('glDrawRangeElementsEXT');

  // GL_EXT_light_texture
  glApplyTextureEXT := wglGetProcAddress('glApplyTextureEXT');
  glTextureLightEXT := wglGetProcAddress('glTextureLightEXT');
  glTextureMaterialEXT := wglGetProcAddress('glTextureMaterialEXT');

  // GL_SGIX_async
  glAsyncMarkerSGIX := wglGetProcAddress('glAsyncMarkerSGIX');
  glFinishAsyncSGIX := wglGetProcAddress('glFinishAsyncSGIX');
  glPollAsyncSGIX := wglGetProcAddress('glPollAsyncSGIX');
  glGenAsyncMarkersSGIX := wglGetProcAddress('glGenAsyncMarkersSGIX');
  glDeleteAsyncMarkersSGIX := wglGetProcAddress('glDeleteAsyncMarkersSGIX');
  glIsAsyncMarkerSGIX := wglGetProcAddress('glIsAsyncMarkerSGIX');

  // GL_INTEL_parallel_arrays
  glVertexPointervINTEL := wglGetProcAddress('glVertexPointervINTEL');
  glNormalPointervINTEL := wglGetProcAddress('glNormalPointervINTEL');
  glColorPointervINTEL := wglGetProcAddress('glColorPointervINTEL');
  glTexCoordPointervINTEL := wglGetProcAddress('glTexCoordPointervINTEL');

  // GL_EXT_pixel_transform
  glPixelTransformParameteriEXT := wglGetProcAddress('glPixelTransformParameteriEXT');
  glPixelTransformParameterfEXT := wglGetProcAddress('glPixelTransformParameterfEXT');
  glPixelTransformParameterivEXT := wglGetProcAddress('glPixelTransformParameterivEXT');
  glPixelTransformParameterfvEXT := wglGetProcAddress('glPixelTransformParameterfvEXT');

  // GL_EXT_secondary_color
  glSecondaryColor3bEXT := wglGetProcAddress('glSecondaryColor3bEXT');
  glSecondaryColor3bvEXT := wglGetProcAddress('glSecondaryColor3bvEXT');
  glSecondaryColor3dEXT := wglGetProcAddress('glSecondaryColor3dEXT');
  glSecondaryColor3dvEXT := wglGetProcAddress('glSecondaryColor3dvEXT');
  glSecondaryColor3fEXT := wglGetProcAddress('glSecondaryColor3fEXT');
  glSecondaryColor3fvEXT := wglGetProcAddress('glSecondaryColor3fvEXT');
  glSecondaryColor3iEXT := wglGetProcAddress('glSecondaryColor3iEXT');
  glSecondaryColor3ivEXT := wglGetProcAddress('glSecondaryColor3ivEXT');
  glSecondaryColor3sEXT := wglGetProcAddress('glSecondaryColor3sEXT');
  glSecondaryColor3svEXT := wglGetProcAddress('glSecondaryColor3svEXT');
  glSecondaryColor3ubEXT := wglGetProcAddress('glSecondaryColor3ubEXT');
  glSecondaryColor3ubvEXT := wglGetProcAddress('glSecondaryColor3ubvEXT');
  glSecondaryColor3uiEXT := wglGetProcAddress('glSecondaryColor3uiEXT');
  glSecondaryColor3uivEXT := wglGetProcAddress('glSecondaryColor3uivEXT');
  glSecondaryColor3usEXT := wglGetProcAddress('glSecondaryColor3usEXT');
  glSecondaryColor3usvEXT := wglGetProcAddress('glSecondaryColor3usvEXT');
  glSecondaryColorPointerEXT := wglGetProcAddress('glSecondaryColorPointerEXT');

  // GL_EXT_texture_perturb_normal
  glTextureNormalEXT := wglGetProcAddress('glTextureNormalEXT');

  // GL_EXT_multi_draw_arrays
  glMultiDrawArraysEXT := wglGetProcAddress('glMultiDrawArraysEXT');
  glMultiDrawElementsEXT := wglGetProcAddress('glMultiDrawElementsEXT');

  // GL_EXT_fog_coord
  glFogCoordfEXT := wglGetProcAddress('glFogCoordfEXT');
  glFogCoordfvEXT := wglGetProcAddress('glFogCoordfvEXT');
  glFogCoorddEXT := wglGetProcAddress('glFogCoorddEXT');
  glFogCoorddvEXT := wglGetProcAddress('glFogCoorddvEXT');
  glFogCoordPointerEXT := wglGetProcAddress('glFogCoordPointerEXT');

  // GL_EXT_coordinate_frame
  glTangent3bEXT := wglGetProcAddress('glTangent3bEXT');
  glTangent3bvEXT := wglGetProcAddress('glTangent3bvEXT');
  glTangent3dEXT := wglGetProcAddress('glTangent3dEXT');
  glTangent3dvEXT := wglGetProcAddress('glTangent3dvEXT');
  glTangent3fEXT := wglGetProcAddress('glTangent3fEXT');
  glTangent3fvEXT := wglGetProcAddress('glTangent3fvEXT');
  glTangent3iEXT := wglGetProcAddress('glTangent3iEXT');
  glTangent3ivEXT := wglGetProcAddress('glTangent3ivEXT');
  glTangent3sEXT := wglGetProcAddress('glTangent3sEXT');
  glTangent3svEXT := wglGetProcAddress('glTangent3svEXT');
  glBinormal3bEXT := wglGetProcAddress('glBinormal3bEXT');
  glBinormal3bvEXT := wglGetProcAddress('glBinormal3bvEXT');
  glBinormal3dEXT := wglGetProcAddress('glBinormal3dEXT');
  glBinormal3dvEXT := wglGetProcAddress('glBinormal3dvEXT');
  glBinormal3fEXT := wglGetProcAddress('glBinormal3fEXT');
  glBinormal3fvEXT := wglGetProcAddress('glBinormal3fvEXT');
  glBinormal3iEXT := wglGetProcAddress('glBinormal3iEXT');
  glBinormal3ivEXT := wglGetProcAddress('glBinormal3ivEXT');
  glBinormal3sEXT := wglGetProcAddress('glBinormal3sEXT');
  glBinormal3svEXT := wglGetProcAddress('glBinormal3svEXT');
  glTangentPointerEXT := wglGetProcAddress('glTangentPointerEXT');
  glBinormalPointerEXT := wglGetProcAddress('glBinormalPointerEXT');

  // GL_SUNX_constant_data
  glFinishTextureSUNX := wglGetProcAddress('glFinishTextureSUNX');

  // GL_SUN_global_alpha
  glGlobalAlphaFactorbSUN := wglGetProcAddress('glGlobalAlphaFactorbSUN');
  glGlobalAlphaFactorsSUN := wglGetProcAddress('glGlobalAlphaFactorsSUN');
  glGlobalAlphaFactoriSUN := wglGetProcAddress('glGlobalAlphaFactoriSUN');
  glGlobalAlphaFactorfSUN := wglGetProcAddress('glGlobalAlphaFactorfSUN');
  glGlobalAlphaFactordSUN := wglGetProcAddress('glGlobalAlphaFactordSUN');
  glGlobalAlphaFactorubSUN := wglGetProcAddress('glGlobalAlphaFactorubSUN');
  glGlobalAlphaFactorusSUN := wglGetProcAddress('glGlobalAlphaFactorusSUN');
  glGlobalAlphaFactoruiSUN := wglGetProcAddress('glGlobalAlphaFactoruiSUN');

  // GL_SUN_triangle_list
  glReplacementCodeuiSUN := wglGetProcAddress('glReplacementCodeuiSUN');
  glReplacementCodeusSUN := wglGetProcAddress('glReplacementCodeusSUN');
  glReplacementCodeubSUN := wglGetProcAddress('glReplacementCodeubSUN');
  glReplacementCodeuivSUN := wglGetProcAddress('glReplacementCodeuivSUN');
  glReplacementCodeusvSUN := wglGetProcAddress('glReplacementCodeusvSUN');
  glReplacementCodeubvSUN := wglGetProcAddress('glReplacementCodeubvSUN');
  glReplacementCodePointerSUN := wglGetProcAddress('glReplacementCodePointerSUN');

  // GL_SUN_vertex
  glColor4ubVertex2fSUN := wglGetProcAddress('glColor4ubVertex2fSUN');
  glColor4ubVertex2fvSUN := wglGetProcAddress('glColor4ubVertex2fvSUN');
  glColor4ubVertex3fSUN := wglGetProcAddress('glColor4ubVertex3fSUN');
  glColor4ubVertex3fvSUN := wglGetProcAddress('glColor4ubVertex3fvSUN');
  glColor3fVertex3fSUN := wglGetProcAddress('glColor3fVertex3fSUN');
  glColor3fVertex3fvSUN := wglGetProcAddress('glColor3fVertex3fvSUN');
  glNormal3fVertex3fSUN := wglGetProcAddress('glNormal3fVertex3fSUN');
  glNormal3fVertex3fvSUN := wglGetProcAddress('glNormal3fVertex3fvSUN');
  glColor4fNormal3fVertex3fSUN := wglGetProcAddress('glColor4fNormal3fVertex3fSUN');
  glColor4fNormal3fVertex3fvSUN := wglGetProcAddress('glColor4fNormal3fVertex3fvSUN');
  glTexCoord2fVertex3fSUN := wglGetProcAddress('glTexCoord2fVertex3fSUN');
  glTexCoord2fVertex3fvSUN := wglGetProcAddress('glTexCoord2fVertex3fvSUN');
  glTexCoord4fVertex4fSUN := wglGetProcAddress('glTexCoord4fVertex4fSUN');
  glTexCoord4fVertex4fvSUN := wglGetProcAddress('glTexCoord4fVertex4fvSUN');
  glTexCoord2fColor4ubVertex3fSUN := wglGetProcAddress('glTexCoord2fColor4ubVertex3fSUN');
  glTexCoord2fColor4ubVertex3fvSUN := wglGetProcAddress('glTexCoord2fColor4ubVertex3fvSUN');
  glTexCoord2fColor3fVertex3fSUN := wglGetProcAddress('glTexCoord2fColor3fVertex3fSUN');
  glTexCoord2fColor3fVertex3fvSUN := wglGetProcAddress('glTexCoord2fColor3fVertex3fvSUN');
  glTexCoord2fNormal3fVertex3fSUN := wglGetProcAddress('glTexCoord2fNormal3fVertex3fSUN');
  glTexCoord2fNormal3fVertex3fvSUN := wglGetProcAddress('glTexCoord2fNormal3fVertex3fvSUN');
  glTexCoord2fColor4fNormal3fVertex3fSUN := wglGetProcAddress('glTexCoord2fColor4fNormal3fVertex3fSUN');
  glTexCoord2fColor4fNormal3fVertex3fvSUN := wglGetProcAddress('glTexCoord2fColor4fNormal3fVertex3fvSUN');
  glTexCoord4fColor4fNormal3fVertex4fSUN := wglGetProcAddress('glTexCoord4fColor4fNormal3fVertex4fSUN');
  glTexCoord4fColor4fNormal3fVertex4fvSUN := wglGetProcAddress('glTexCoord4fColor4fNormal3fVertex4fvSUN');
  glReplacementCodeuiVertex3fSUN := wglGetProcAddress('glReplacementCodeuiVertex3fSUN');
  glReplacementCodeuiVertex3fvSUN := wglGetProcAddress('glReplacementCodeuiVertex3fvSUN');
  glReplacementCodeuiColor4ubVertex3fSUN := wglGetProcAddress('glReplacementCodeuiColor4ubVertex3fSUN');
  glReplacementCodeuiColor4ubVertex3fvSUN := wglGetProcAddress('glReplacementCodeuiColor4ubVertex3fvSUN');
  glReplacementCodeuiColor3fVertex3fSUN := wglGetProcAddress('glReplacementCodeuiColor3fVertex3fSUN');
  glReplacementCodeuiColor3fVertex3fvSUN := wglGetProcAddress('glReplacementCodeuiColor3fVertex3fvSUN');
  glReplacementCodeuiNormal3fVertex3fSUN := wglGetProcAddress('glReplacementCodeuiNormal3fVertex3fSUN');
  glReplacementCodeuiNormal3fVertex3fvSUN := wglGetProcAddress('glReplacementCodeuiNormal3fVertex3fvSUN');
  glReplacementCodeuiColor4fNormal3fVertex3fSUN := wglGetProcAddress('glReplacementCodeuiColor4fNormal3fVertex3fSUN');
  glReplacementCodeuiColor4fNormal3fVertex3fvSUN := wglGetProcAddress('glReplacementCodeuiColor4fNormal3fVertex3fvSUN');
  glReplacementCodeuiTexCoord2fVertex3fSUN := wglGetProcAddress('glReplacementCodeuiTexCoord2fVertex3fSUN');
  glReplacementCodeuiTexCoord2fVertex3fvSUN := wglGetProcAddress('glReplacementCodeuiTexCoord2fVertex3fvSUN');
  glReplacementCodeuiTexCoord2fNormal3fVertex3fSUN := wglGetProcAddress('glReplacementCodeuiTexCoord2fNormal3fVertex3fSUN');
  glReplacementCodeuiTexCoord2fNormal3fVertex3fvSUN := wglGetProcAddress('glReplacementCodeuiTexCoord2fNormal3fVertex3fvSUN');
  glReplacementCodeuiTexCoord2fColor4fNormal3fVertex3fSUN := wglGetProcAddress('glReplacementCodeuiTexCoord2fColor4fNormal3fVertex3fSUN');
  glReplacementCodeuiTexCoord2fColor4fNormal3fVertex3fvSUN := wglGetProcAddress('glReplacementCodeuiTexCoord2fColor4fNormal3fVertex3fvSUN');

  // GL_EXT_blend_func_separate
  glBlendFuncSeparateEXT := wglGetProcAddress('glBlendFuncSeparateEXT');

  // GL_EXT_vertex_weighting
  glVertexWeightfEXT := wglGetProcAddress('glVertexWeightfEXT');
  glVertexWeightfvEXT := wglGetProcAddress('glVertexWeightfvEXT');
  glVertexWeightPointerEXT := wglGetProcAddress('glVertexWeightPointerEXT');

  // GL_NV_vertex_array_range
  glFlushVertexArrayRangeNV := wglGetProcAddress('glFlushVertexArrayRangeNV');
  glVertexArrayRangeNV := wglGetProcAddress('glVertexArrayRangeNV');
  wglAllocateMemoryNV := wglGetProcAddress('wglAllocateMemoryNV');
  wglFreeMemoryNV := wglGetProcaddress('wglFreeMemoryNV');

  // GL_NV_register_combiners
  glCombinerParameterfvNV := wglGetProcAddress('glCombinerParameterfvNV');
  glCombinerParameterfNV := wglGetProcAddress('glCombinerParameterfNV');
  glCombinerParameterivNV := wglGetProcAddress('glCombinerParameterivNV');
  glCombinerParameteriNV := wglGetProcAddress('glCombinerParameteriNV');
  glCombinerInputNV := wglGetProcAddress('glCombinerInputNV');
  glCombinerOutputNV := wglGetProcAddress('glCombinerOutputNV');
  glFinalCombinerInputNV := wglGetProcAddress('glFinalCombinerInputNV');
  glGetCombinerInputParameterfvNV := wglGetProcAddress('glGetCombinerInputParameterfvNV');
  glGetCombinerInputParameterivNV := wglGetProcAddress('glGetCombinerInputParameterivNV');
  glGetCombinerOutputParameterfvNV := wglGetProcAddress('glGetCombinerOutputParameterfvNV');
  glGetCombinerOutputParameterivNV := wglGetProcAddress('glGetCombinerOutputParameterivNV');
  glGetFinalCombinerInputParameterfvNV := wglGetProcAddress('glGetFinalCombinerInputParameterfvNV');
  glGetFinalCombinerInputParameterivNV := wglGetProcAddress('glGetFinalCombinerInputParameterivNV');

  // GL_MESA_resize_buffers
  glResizeBuffersMESA := wglGetProcAddress('glResizeBuffersMESA');

  // GL_MESA_window_pos
  glWindowPos2dMESA := wglGetProcAddress('glWindowPos2dMESA');
  glWindowPos2dvMESA := wglGetProcAddress('glWindowPos2dvMESA');
  glWindowPos2fMESA := wglGetProcAddress('glWindowPos2fMESA');
  glWindowPos2fvMESA := wglGetProcAddress('glWindowPos2fvMESA');
  glWindowPos2iMESA := wglGetProcAddress('glWindowPos2iMESA');
  glWindowPos2ivMESA := wglGetProcAddress('glWindowPos2ivMESA');
  glWindowPos2sMESA := wglGetProcAddress('glWindowPos2sMESA');
  glWindowPos2svMESA := wglGetProcAddress('glWindowPos2svMESA');
  glWindowPos3dMESA := wglGetProcAddress('glWindowPos3dMESA');
  glWindowPos3dvMESA := wglGetProcAddress('glWindowPos3dvMESA');
  glWindowPos3fMESA := wglGetProcAddress('glWindowPos3fMESA');
  glWindowPos3fvMESA := wglGetProcAddress('glWindowPos3fvMESA');
  glWindowPos3iMESA := wglGetProcAddress('glWindowPos3iMESA');
  glWindowPos3ivMESA := wglGetProcAddress('glWindowPos3ivMESA');
  glWindowPos3sMESA := wglGetProcAddress('glWindowPos3sMESA');
  glWindowPos3svMESA := wglGetProcAddress('glWindowPos3svMESA');
  glWindowPos4dMESA := wglGetProcAddress('glWindowPos4dMESA');
  glWindowPos4dvMESA := wglGetProcAddress('glWindowPos4dvMESA');
  glWindowPos4fMESA := wglGetProcAddress('glWindowPos4fMESA');
  glWindowPos4fvMESA := wglGetProcAddress('glWindowPos4fvMESA');
  glWindowPos4iMESA := wglGetProcAddress('glWindowPos4iMESA');
  glWindowPos4ivMESA := wglGetProcAddress('glWindowPos4ivMESA');
  glWindowPos4sMESA := wglGetProcAddress('glWindowPos4sMESA');
  glWindowPos4svMESA := wglGetProcAddress('glWindowPos4svMESA');

  // GL_IBM_multimode_draw_arrays
  glMultiModeDrawArraysIBM := wglGetProcAddress('glMultiModeDrawArraysIBM');
  glMultiModeDrawElementsIBM := wglGetProcAddress('glMultiModeDrawElementsIBM');

  // GL_IBM_vertex_array_lists
  glColorPointerListIBM := wglGetProcAddress('glColorPointerListIBM');
  glSecondaryColorPointerListIBM := wglGetProcAddress('glSecondaryColorPointerListIBM');
  glEdgeFlagPointerListIBM := wglGetProcAddress('glEdgeFlagPointerListIBM');
  glFogCoordPointerListIBM := wglGetProcAddress('glFogCoordPointerListIBM');
  glIndexPointerListIBM := wglGetProcAddress('glIndexPointerListIBM');
  glNormalPointerListIBM := wglGetProcAddress('glNormalPointerListIBM');
  glTexCoordPointerListIBM := wglGetProcAddress('glTexCoordPointerListIBM');
  glVertexPointerListIBM := wglGetProcAddress('glVertexPointerListIBM');

  // GL_3DFX_tbuffer
  glTbufferMask3DFX := wglGetProcAddress('glTbufferMask3DFX');

  // GL_EXT_multisample
  glSampleMaskEXT := wglGetProcAddress('glSampleMaskEXT');
  glSamplePatternEXT := wglGetProcAddress('glSamplePatternEXT');

  // GL_SGIS_texture_color_mask
  glTextureColorMaskSGIS := wglGetProcAddress('glTextureColorMaskSGIS');

  // GL_SGIX_igloo_interface
  glIglooInterfaceSGIX := wglGetProcAddress('glIglooInterfaceSGIX');

  // GLU extensions
  gluNurbsCallbackDataEXT := wglGetProcAddress('gluNurbsCallbackDataEXT');
  gluNewNurbsTessellatorEXT := wglGetProcAddress('gluNewNurbsTessellatorEXT');
  gluDeleteNurbsTessellatorEXT := wglGetProcAddress('gluDeleteNurbsTessellatorEXT');

  // to get synchronized again, if this proc was called externally
  LastPixelFormat := 0;
end;

{}
//----------------------------------------------------------------------------------------------------------------------

procedure TrimAndSplitVersionString(Buffer: String; var Max, Min: Integer);

// peel out the X.Y form

var
  Separator: Integer;

begin
  try
    // there must be at least one dot to separate major and minor version number
    Separator := Pos('.', Buffer);
    // at least one number must be before and one after the dot
    if (Separator > 1) and (Separator < Length(Buffer)) and (Buffer[Separator - 1] in ['0'..'9']) and
      (Buffer[Separator + 1] in ['0'..'9']) then
    begin
      // ok, it's a valid version string
      // now remove unnecessary parts
      Dec(Separator);
      // find last non-numeric character before version number
      while (Separator > 0) and (Buffer[Separator] in ['0'..'9']) do
        Dec(Separator);
      // delete leading characters not belonging to the version string
      Delete(Buffer, 1, Separator);
      Separator := Pos('.', Buffer) + 1;
      // find first non-numeric character after version number
      while (Separator <= Length(Buffer)) and (Buffer[Separator] in ['0'..'9']) do
        Inc(Separator);
      // delete trailing characters not belonging to the version string
      Delete(Buffer, Separator, 255);
      // now translate the numbers
      Separator := Pos('.', Buffer); // necessary, because the buffer length may be changed
      Max := Str2Int(Copy(Buffer, 1, Separator - 1));
      Min := Str2Int(Copy(Buffer, Separator + 1, 255));
    end
    else
      Abort;
  except
    Min := 0;
    Max := 0;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function GL_CheckExtension(AFlag: TExtensionsFlag;const Extension: String): Boolean;
begin
  if AFlag in CheckedExtensions then
    result:= AFlag in CurentExtensions
  else
  begin
    result := Pos(Extension, GL_SBuffer) > 0;
    include(CheckedExtensions,AFlag);
    if result then
      include(CurentExtensions,AFlag)
    else
      exclude(CurentExtensions,AFlag);
  end;
end;

function GL_3DFX_multisample:boolean;
begin
  result:=GL_CheckExtension(fGL_3DFX_multisample,'GL_3DFX_multisample');
end;

function GL_3DFX_tbuffer: boolean;
begin
  result:=GL_CheckExtension(fGL_3DFX_tbuffer,'GL_3DFX_tbuffer');
end;

function GL_3DFX_texture_compression_FXT1: boolean;
begin
  result:=GL_CheckExtension(fGL_3DFX_texture_compression_FXT1 ,' GL_3DFX_texture_compression_FXT1');
end;

function GL_APPLE_specular_vector: boolean;
begin
  result:=GL_CheckExtension(fGL_APPLE_specular_vector ,'GL_APPLE_specular_vector');
end;

function GL_APPLE_transform_hint: boolean;
begin
  result:=GL_CheckExtension(fGL_APPLE_transform_hint,'GL_APPLE_transform_hint');
end;
 
function GL_ARB_imaging: boolean;
begin
  result:=GL_CheckExtension(fGL_ARB_imaging,'GL_ARB_imaging');
end;

function GL_ARB_multisample: boolean;
begin
  result:=GL_CheckExtension(fGL_ARB_multisample,'GL_ARB_multisample');
end;

function GL_ARB_multitexture: boolean;
begin
  result:=GL_CheckExtension(fGL_ARB_multitexture,'GL_ARB_multitexture');
end;

function GL_ARB_texture_compression: boolean;
begin
  result:=GL_CheckExtension(fGL_ARB_texture_compression,'GL_ARB_texture_compression');
end;

function GL_ARB_texture_cube_map: boolean;
begin
  result:=GL_CheckExtension(fGL_ARB_texture_cube_map,'GL_ARB_texture_cube_map');
end;

function GL_ARB_transpose_matrix: boolean;
begin
  result:=GL_CheckExtension(fGL_ARB_transpose_matrix,'GL_ARB_transpose_matrix');
end;

function GL_ARB_vertex_blend: boolean;
begin
  result:=GL_CheckExtension(fGL_ARB_vertex_blend,'GL_ARB_vertex_blend');
end;

function GL_EXT_422_pixels: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_422_pixels,'GL_EXT_422_pixels');
end;

function GL_EXT_abgr: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_abgr,'GL_EXT_abgr');
end;

function GL_EXT_bgra: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_bgra,'GL_EXT_bgra');
end;

function GL_EXT_blend_color: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_blend_color,'GL_EXT_blend_color');
end;

function GL_EXT_blend_func_separate: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_blend_func_separate,'GL_EXT_blend_func_separate');
end;

function GL_EXT_blend_logic_op: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_blend_logic_op,'GL_EXT_blend_logic_op');
end;

function GL_EXT_blend_minmax: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_blend_minmax,'GL_EXT_blend_minmax');
end;

function GL_EXT_blend_subtract: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_blend_subtract,'GL_EXT_blend_subtract');
end;

function GL_EXT_clip_volume_hint: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_clip_volume_hint,'GL_EXT_clip_volume_hint');
end;

function GL_EXT_cmyka: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_cmyka,'GL_EXT_cmyka');
end;

function GL_EXT_color_subtable: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_color_subtable,'GL_EXT_color_subtable');
end;

function GL_EXT_compiled_vertex_array: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_compiled_vertex_array,'GL_EXT_compiled_vertex_array');
end;

function GL_EXT_convolution: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_convolution,'GL_EXT_convolution');
end;

function GL_EXT_coordinate_frame: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_coordinate_frame,'GL_EXT_coordinate_frame');
end;

function GL_EXT_copy_texture: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_copy_texture,'GL_EXT_copy_texture');
end;

function GL_EXT_cull_vertex: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_cull_vertex,'GL_EXT_cull_vertex');
end;

function GL_EXT_draw_range_elements: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_draw_range_elements,'GL_EXT_draw_range_elements');
end;

function GL_EXT_fog_coord: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_fog_coord,'GL_EXT_fog_coord');
end;

function GL_EXT_histogram: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_histogram,'GL_EXT_histogram');
end;

function GL_EXT_index_array_formats: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_index_array_formats,'GL_EXT_index_array_formats');
end;

function GL_EXT_index_func: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_index_func,'GL_EXT_index_func');
end;

function GL_EXT_index_material: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_index_material,'GL_EXT_index_material');
end;

function GL_EXT_index_texture: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_index_texture,'GL_EXT_index_texture');
end;

function GL_EXT_light_max_exponent: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_light_max_exponent,'GL_EXT_light_max_exponent');
end;

function GL_EXT_light_texture: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_light_texture,'GL_EXT_light_texture');
end;

function GL_EXT_misc_attribute: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_misc_attribute,'GL_EXT_misc_attribute');
end;

function GL_EXT_multi_draw_arrays: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_multi_draw_arrays,'GL_EXT_multi_draw_arrays');
end;

function GL_EXT_multisample: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_multisample,'GL_EXT_multisample');
end;

function GL_EXT_packed_pixels: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_packed_pixels,'GL_EXT_packed_pixels');
end;

function GL_EXT_paletted_texture: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_paletted_texture,'GL_EXT_paletted_texture');
end;

function GL_EXT_pixel_transform: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_pixel_transform,'GL_EXT_pixel_transform');
end;

function GL_EXT_point_parameters: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_point_parameters,'GL_EXT_point_parameters');
end;

function GL_EXT_polygon_offset: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_polygon_offset,'GL_EXT_polygon_offset');
end;

function GL_EXT_rescale_normal: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_rescale_normal,'GL_EXT_rescale_normal');
end;

function GL_EXT_scene_marker: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_scene_marker,'GL_EXT_scene_marker');
end;

function GL_EXT_secondary_color: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_secondary_color,'GL_EXT_secondary_color');
end;

function GL_EXT_separate_specular_color: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_separate_specular_color,'GL_EXT_separate_specular_color');
end;

function GL_EXT_shared_texture_palette: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_shared_texture_palette,'GL_EXT_shared_texture_palette');
end;

function GL_EXT_stencil_wrap: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_stencil_wrap,'GL_EXT_stencil_wrap');
end;

function GL_EXT_subtexture: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_subtexture,'GL_EXT_subtexture');
end;

function GL_EXT_texture_color_table: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_texture_color_table,'GL_EXT_texture_color_table');
end;

function GL_EXT_texture_compression_s3tc: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_texture_compression_s3tc,'GL_EXT_texture_compression_s3tc');
end;

function GL_EXT_texture_cube_map: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_texture_cube_map,'GL_EXT_texture_cube_map');
end;

function GL_EXT_texture_edge_clamp: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_texture_edge_clamp,'GL_EXT_texture_edge_clamp');
end;

function GL_EXT_texture_env_add: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_texture_env_add,'GL_EXT_texture_env_add');
end;

function GL_EXT_texture_env_combine: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_texture_env_combine,'GL_EXT_texture_env_combine');
end;

function GL_EXT_texture_filter_anisotropic: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_texture_filter_anisotropic,'GL_EXT_texture_filter_anisotropic');
end;

function GL_EXT_texture_lod_bias: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_texture_lod_bias,'GL_EXT_texture_lod_bias');
end;

function GL_EXT_texture_object: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_texture_object,'GL_EXT_texture_object');
end;

function GL_EXT_texture_perturb_normal: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_texture_perturb_normal,'GL_EXT_texture_perturb_normal');
end;

function GL_EXT_texture3D: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_texture3D,'GL_EXT_texture3D');
end;

function GL_EXT_vertex_array: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_vertex_array,'GL_EXT_vertex_array');
end;

function GL_EXT_vertex_weighting: boolean;
begin
  result:=GL_CheckExtension(fGL_EXT_vertex_weighting,'GL_EXT_vertex_weighting');
end;

function GL_FfdMaskSGIX: boolean;
begin
  result:=GL_CheckExtension(fGL_FfdMaskSGIX,'GL_FfdMaskSGIX');
end;

function GL_HP_convolution_border_modes: boolean;
begin
  result:=GL_CheckExtension(fGL_HP_convolution_border_modes,'GL_HP_convolution_border_modes');
end;

function GL_HP_image_transform: boolean;
begin
  result:=GL_CheckExtension(fGL_HP_image_transform,'GL_HP_image_transform');
end;

function GL_HP_occlusion_test: boolean;
begin
  result:=GL_CheckExtension(fGL_HP_occlusion_test,'GL_HP_occlusion_test');
end;

function GL_HP_texture_lighting: boolean;
begin
  result:=GL_CheckExtension(fGL_HP_texture_lighting,'GL_HP_texture_lighting');
end;

function GL_IBM_cull_vertex: boolean;
begin
  result:=GL_CheckExtension(fGL_IBM_cull_vertex,'GL_IBM_cull_vertex');
end;

function GL_IBM_multimode_draw_arrays: boolean;
begin
  result:=GL_CheckExtension(fGL_IBM_multimode_draw_arrays,'GL_IBM_multimode_draw_arrays');
end;

function GL_IBM_rasterpos_clip: boolean;
begin
  result:=GL_CheckExtension(fGL_IBM_rasterpos_clip,'GL_IBM_rasterpos_clip');
end;

function GL_IBM_vertex_array_lists: boolean;
begin
  result:=GL_CheckExtension(fGL_IBM_vertex_array_lists,'GL_IBM_vertex_array_lists');
end;

function GL_INGR_color_clamp: boolean;
begin
  result:=GL_CheckExtension(fGL_INGR_color_clamp,'GL_INGR_color_clamp');
end;

function GL_INGR_interlace_read: boolean;
begin
  result:=GL_CheckExtension(fGL_INGR_interlace_read,'GL_INGR_interlace_read');
end;

function GL_INTEL_parallel_arrays: boolean;
begin
  result:=GL_CheckExtension(fGL_INTEL_parallel_arrays,'GL_INTEL_parallel_arrays');
end;

function GL_KTX_buffer_region: boolean;
begin
  result:=GL_CheckExtension(fGL_KTX_buffer_region,'GL_KTX_buffer_region');
end;

function GL_MESA_resize_buffers: boolean;
begin
  result:=GL_CheckExtension(fGL_MESA_resize_buffers,'GL_MESA_resize_buffers');
end;

function GL_MESA_window_pos: boolean;
begin
  result:=GL_CheckExtension(fGL_MESA_window_pos,'GL_MESA_window_pos');
end;
 
function GL_NV_blend_square: boolean;
begin
  result:=GL_CheckExtension(fGL_NV_blend_square,'GL_NV_blend_square');
end;
 
function GL_NV_fog_distance: boolean;
begin
  result:=GL_CheckExtension(fGL_NV_fog_distance,'GL_NV_fog_distance');
end;
 
function GL_NV_light_max_exponent: boolean;
begin
  result:=GL_CheckExtension(fGL_NV_light_max_exponent,'GL_NV_light_max_exponent');
end;
 
function GL_NV_register_combiners: boolean;
begin
  result:=GL_CheckExtension(fGL_NV_register_combiners,'GL_NV_register_combiners');
end;
 
function GL_NV_texgen_emboss: boolean;
begin
  result:=GL_CheckExtension(fGL_NV_texgen_emboss,'GL_NV_texgen_emboss');
end;

function GL_NV_texgen_reflection: boolean;
begin
  result:=GL_CheckExtension(fGL_NV_texgen_reflection,'GL_NV_texgen_reflection');
end;
 
function GL_NV_texture_env_combine4: boolean;
begin
  result:=GL_CheckExtension(fGL_NV_texture_env_combine4,'GL_NV_texture_env_combine4');
end;

function GL_NV_vertex_array_range: boolean;
begin
  result:=GL_CheckExtension(fGL_NV_vertex_array_range,'GL_NV_vertex_array_range');
end;
 
function GL_PGI_misc_hints: boolean;
begin
  result:=GL_CheckExtension(fGL_PGI_misc_hints,'GL_PGI_misc_hints');
end;
 
function GL_PGI_vertex_hints: boolean;
begin
  result:=GL_CheckExtension(fGL_PGI_vertex_hints,'GL_PGI_vertex_hints');
end;

function GL_REND_screen_coordinates: boolean;
begin
  result:=GL_CheckExtension(fGL_REND_screen_coordinates,'GL_REND_screen_coordinates');
end;
 
function GL_SGI_color_matrix: boolean;
begin
  result:=GL_CheckExtension(fGL_SGI_color_matrix,'GL_SGI_color_matrix');
end;
 
function GL_SGI_color_table: boolean;
begin
  result:=GL_CheckExtension(fGL_SGI_color_table,'GL_SGI_color_table');
end;
 
function GL_SGI_depth_pass_instrument: boolean;
begin
  result:=GL_CheckExtension(fGL_SGI_depth_pass_instrument,'GL_SGI_depth_pass_instrument');
end;
 
function GL_SGIS_detail_texture: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIS_detail_texture,'GL_SGIS_detail_texture');
end;
 
function GL_SGIS_fog_function: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIS_fog_function,'GL_SGIS_fog_function');
end;
 
function GL_SGIS_generate_mipmap: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIS_generate_mipmap,'GL_SGIS_generate_mipmap');
end;
 
function GL_SGIS_multisample: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIS_multisample,'GL_SGIS_multisample');
end;

function GL_SGIS_multitexture: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIS_multitexture,'GL_SGIS_multitexture');
end;
 
function GL_SGIS_pixel_texture: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIS_pixel_texture,'GL_SGIS_pixel_texture');
end;
 
function GL_SGIS_point_line_texgen: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIS_point_line_texgen,'GL_SGIS_point_line_texgen');
end;
 
function GL_SGIS_point_parameters: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIS_point_parameters,'GL_SGIS_point_parameters');
end;
 
function GL_SGIS_sharpen_texture: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIS_sharpen_texture,'GL_SGIS_sharpen_texture');
end;
 
function GL_SGIS_texture_border_clamp: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIS_texture_border_clamp,'GL_SGIS_texture_border_clamp');
end;
 
function GL_SGIS_texture_color_mask: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIS_texture_color_mask,'GL_SGIS_texture_color_mask');
end;
 
function GL_SGIS_texture_edge_clamp: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIS_texture_edge_clamp,'GL_SGIS_texture_edge_clamp');
end;
 
function GL_SGIS_texture_filter4: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIS_texture_filter4,'GL_SGIS_texture_filter4');
end;
 
function GL_SGIS_texture_lod: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIS_texture_lod,'GL_SGIS_texture_lod');
end;
 
function GL_SGIS_texture_select: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIS_texture_select,'GL_SGIS_texture_select');
end;
 
function GL_SGIS_texture4D: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIS_texture4D,'GL_SGIS_texture4D');
end;
 
function GL_SGIX_async: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_async,'GL_SGIX_async');
end;
 
function GL_SGIX_async_histogram: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_async_histogram,'GL_SGIX_async_histogram');
end;
 
function GL_SGIX_async_pixel: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_async_pixel,'GL_SGIX_async_pixel');
end;
 
function GL_SGIX_blend_alpha_minmax: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_blend_alpha_minmax,'GL_SGIX_blend_alpha_minmax');
end;
 
function GL_SGIX_calligraphic_fragment: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_calligraphic_fragment,'GL_SGIX_calligraphic_fragment');
end;
 
function GL_SGIX_clipmap: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_clipmap,'GL_SGIX_clipmap');
end;
 
function GL_SGIX_convolution_accuracy: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_convolution_accuracy,'GL_SGIX_convolution_accuracy');
end;

function GL_SGIX_depth_texture: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_depth_texture,'GL_SGIX_depth_texture');
end;

function GL_SGIX_flush_raster: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_flush_raster,'GL_SGIX_flush_raster');
end;
 
function GL_SGIX_fog_offset: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_fog_offset,'GL_SGIX_fog_offset');
end;
 
function GL_SGIX_fog_scale: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_fog_scale,'GL_SGIX_fog_scale');
end;
 
function GL_SGIX_fragment_lighting: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_fragment_lighting,'GL_SGIX_fragment_lighting');
end;
 
function GL_SGIX_framezoom: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_framezoom,'GL_SGIX_framezoom');
end;

function GL_SGIX_igloo_interface: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_igloo_interface,'GL_SGIX_igloo_interface');
end;
 
function GL_SGIX_instruments: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_instruments,'GL_SGIX_instruments');
end;
 
function GL_SGIX_interlace: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_interlace,'GL_SGIX_interlace');
end;

function GL_SGIX_ir_instrument1: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_ir_instrument1,'GL_SGIX_ir_instrument1');
end;
 
function GL_SGIX_list_priority: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_list_priority,'GL_SGIX_list_priority');
end;
 
function GL_SGIX_pixel_texture: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_pixel_texture,'GL_SGIX_pixel_texture');
end;
 
function GL_SGIX_pixel_tiles: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_pixel_tiles,'GL_SGIX_pixel_tiles');
end;
 
function GL_SGIX_polynomial_ffd: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_polynomial_ffd,'GL_SGIX_polynomial_ffd');
end;
 
function GL_SGIX_reference_plane: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_reference_plane,'GL_SGIX_reference_plane');
end;
 
function GL_SGIX_resample: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_resample,'GL_SGIX_resample');
end;
 
function GL_SGIX_shadow: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_shadow,'GL_SGIX_shadow');
end;
 
function GL_SGIX_shadow_ambient: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_shadow_ambient,'GL_SGIX_shadow_ambient');
end;
 
function GL_SGIX_sprite: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_sprite,'GL_SGIX_sprite');
end;
 
function GL_SGIX_subsample: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_subsample,'GL_SGIX_subsample');
end;
 
function GL_SGIX_tag_sample_buffer: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_tag_sample_buffer,'GL_SGIX_tag_sample_buffer');
end;
 
function GL_SGIX_texture_add_env: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_texture_add_env,'GL_SGIX_texture_add_env');
end;
 
function GL_SGIX_texture_lod_bias: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_texture_lod_bias,'GL_SGIX_texture_lod_bias');
end;
 
function GL_SGIX_texture_multi_buffer: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_texture_multi_buffer,'GL_SGIX_texture_multi_buffer');
end;
 
function GL_SGIX_texture_scale_bias: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_texture_scale_bias,'GL_SGIX_texture_scale_bias');
end;
 
function GL_SGIX_vertex_preclip: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_vertex_preclip,'GL_SGIX_vertex_preclip');
end;
 
function GL_SGIX_ycrcb: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_ycrcb,'GL_SGIX_ycrcb');
end;

function GL_SGIX_ycrcba: boolean;
begin
  result:=GL_CheckExtension(fGL_SGIX_ycrcba,'GL_SGIX_ycrcba');
end;
 
function GL_SUN_convolution_border_modes: boolean;
begin
  result:=GL_CheckExtension(fGL_SUN_convolution_border_modes,'GL_SUN_convolution_border_modes');
end;

function GL_SUN_global_alpha: boolean;
begin
  result:=GL_CheckExtension(fGL_SUN_global_alpha,'GL_SUN_global_alpha');
end;
 
function GL_SUN_triangle_list: boolean;
begin
  result:=GL_CheckExtension(fGL_SUN_triangle_list,'GL_SUN_triangle_list');
end;
 
function GL_SUN_vertex: boolean;
begin
  result:=GL_CheckExtension(fGL_SUN_vertex,'GL_SUN_vertex');
end;
 
function GL_SUNX_constant_data: boolean;
begin
  result:=GL_CheckExtension(fGL_SUNX_constant_data,'GL_SUNX_constant_data');
end;
 
function GL_WIN_phong_shading: boolean;
begin
  result:=GL_CheckExtension(fGL_WIN_phong_shading,'GL_WIN_phong_shading');
end;
 
function GL_WIN_specular_fog: boolean;
begin
  result:=GL_CheckExtension(fGL_WIN_specular_fog,'GL_WIN_specular_fog');
end;
 
function GL_WIN_swap_hint: boolean;
begin
  result:=GL_CheckExtension(fGL_WIN_swap_hint,'GL_WIN_swap_hint');
end;
 
function WGL_EXT_swap_control: boolean;
begin
  result:=GL_CheckExtension(fWGL_EXT_swap_control,'WGL_EXT_swap_control');
end;

function GLU_CheckExtension(AFlag: TExtensionsFlag;const Extension: String): Boolean;
begin
  if AFlag in CheckedExtensions then
    result:= AFlag in CurentExtensions
  else
  begin
    result := Pos(Extension, GLU_SBuffer) > 0;
    include(CheckedExtensions,AFlag);
    if result then
      include(CurentExtensions,AFlag)
    else
      exclude(CurentExtensions,AFlag);
  end;
end;


function GLU_EXT_TEXTURE: boolean;
begin
  result:=GLU_CheckExtension(fGLU_EXT_TEXTURE,'GLU_EXT_TEXTURE');
end;

function GLU_EXT_object_space_tess: boolean;
begin
  result:=GLU_CheckExtension(fGLU_EXT_object_space_tess,'GLU_EXT_object_space_tess');
end;

function GLU_EXT_nurbs_tessellator: boolean;
begin
  result:=GLU_CheckExtension(fGLU_EXT_nurbs_tessellator,'GLU_EXT_nurbs_tessellator');
end;


procedure ReadImplementationProperties;

var
  Buffer: String;
  MajorVersion,
  MinorVersion: Integer;

  //--------------- local function --------------------------------------------

   function CheckExtension(const Extension: String): Boolean;
   begin
     Result := Pos(Extension, Buffer) > 0;
   end;

  //--------------- end local function ----------------------------------------

begin
  // determine version of implementation
  // GL
  Buffer := glGetString(GL_VERSION);
  TrimAndSplitVersionString(Buffer, Majorversion, MinorVersion);
  GL_VERSION_1_0 := True;
  GL_VERSION_1_1 := False;
  GL_VERSION_1_2 := False;
  if MajorVersion > 0 then
  begin
    if MinorVersion > 0 then
    begin
      GL_VERSION_1_1 := True;
      if MinorVersion > 1 then
        GL_VERSION_1_2 := True;
    end;
  end;

  // GLU
  GLU_VERSION_1_1 := False;
  GLU_VERSION_1_2 := False;
  GLU_VERSION_1_3 := False;
  // gluGetString is valid for version 1.1 or later
  if assigned(gluGetString) then
  begin
    Buffer := gluGetString(GLU_VERSION);
    TrimAndSplitVersionString(Buffer, Majorversion, MinorVersion);
    GLU_VERSION_1_1 := True;
    if MinorVersion > 1 then
    begin
      GLU_VERSION_1_2 := True;
      if MinorVersion > 2 then
        GLU_VERSION_1_3 := True;
    end;
  end;

  GL_SBuffer := glGetString(GL_EXTENSIONS);
  GLU_SBuffer := glGetString(GLU_EXTENSIONS);
end;

//----------------------------------------------------------------------------------------------------------------------

function SetupPalette(DC: HDC; PFD: TPixelFormatDescriptor): HPalette;

var
  nColors,
  I: Integer;
  LogPalette: TMaxLogPalette;
  RedMask,
  GreenMask,
  BlueMask: Byte;

begin
  nColors := 1 shl Pfd.cColorBits;
  LogPalette.palVersion := $300;
  LogPalette.palNumEntries := nColors;
  RedMask := (1 shl Pfd.cRedBits  ) - 1;
  GreenMask := (1 shl Pfd.cGreenBits) - 1;
  BlueMask := (1 shl Pfd.cBlueBits ) - 1;
  with LogPalette, PFD do
    for I := 0 to nColors - 1 do
    begin
      palPalEntry[I].peRed := (((I shr cRedShift  ) and RedMask  ) * 255) div RedMask;
      palPalEntry[I].peGreen := (((I shr cGreenShift) and GreenMask) * 255) div GreenMask;
      palPalEntry[I].peBlue := (((I shr cBlueShift ) and BlueMask ) * 255) div BlueMask;
      palPalEntry[I].peFlags := 0;
    end;

  Result := CreatePalette(PLogPalette(@LogPalette)^);
  if Result <> 0 then
  begin
    SelectPalette(DC, Result, False);
    RealizePalette(DC);
  end
  else
    RaiseLastWin32Error;
end;

//----------------------------------------------------------------------------------------------------------------------

function CreateRenderingContext(DC: HDC; Options: TRCOptions; ColorBits, StencilBits, AccumBits, AuxBuffers: Integer;
  Layer: Integer): HGLRC;

// Set the OpenGL properties required to draw to the given canvas and
// create a rendering context for it.

const
  MemoryDCs = [OBJ_MEMDC, OBJ_METADC, OBJ_ENHMETADC];

var
  PFDescriptor: TPixelFormatDescriptor;
  PixelFormat: Integer;
  AType: DWORD;

begin
  FillChar(PFDescriptor, SizeOf(PFDescriptor), 0);
  with PFDescriptor do
  begin
    nSize := SizeOf(PFDescriptor);
    nVersion := 1;
    dwFlags := PFD_SUPPORT_OPENGL;
    AType := GetObjectType(DC);
    if AType = 0 then
      RaiseLastWin32Error;
      
    if AType in MemoryDCs then
      dwFlags := dwFlags or PFD_DRAW_TO_BITMAP
    else
      dwFlags := dwFlags or PFD_DRAW_TO_WINDOW;
    if opDoubleBuffered in Options then
      dwFlags := dwFlags or PFD_DOUBLEBUFFER;
    if opGDI in Options then
      dwFlags := dwFlags or PFD_SUPPORT_GDI;
    if opStereo in Options then
      dwFlags := dwFlags or PFD_STEREO;
    iPixelType := PFD_TYPE_RGBA;
    cColorBits := ColorBits;
    cDepthBits := 32;
    cStencilBits := StencilBits;
    cAccumBits := AccumBits;
    cAuxBuffers := AuxBuffers;
    if Layer = 0 then
      iLayerType := PFD_MAIN_PLANE
    else
      if Layer > 0 then
        iLayerType := PFD_OVERLAY_PLANE
      else
        iLayerType := Byte(PFD_UNDERLAY_PLANE);
  end;

  // just in case it didn't happen already
  if not InitOpenGL then
    RaiseLastWin32Error;
  PixelFormat := ChoosePixelFormat(DC, @PFDescriptor);
  if PixelFormat = 0 then
    RaiseLastWin32Error;

  // NOTE: It is not allowed to change a pixel format of a device context once it has been set.
  //       So cache DC and RC always somewhere to avoid re-setting the pixel format!
  if not SetPixelFormat(DC, PixelFormat, @PFDescriptor) then
    RaiseLastWin32Error;

  // check the properties just set
  DescribePixelFormat(DC, PixelFormat, SizeOf(PFDescriptor), PFDescriptor);
  with PFDescriptor do
    if ((dwFlags and PFD_NEED_PALETTE) <> 0) then
      SetupPalette(DC, PFDescriptor);

  Result := wglCreateLayerContext(DC, Layer);
  if Result = 0 then
    RaiseLastWin32Error
  else
    LastPixelFormat := 0;
end;

//----------------------------------------------------------------------------------------------------------------------
procedure InitGLExtensions;
begin
  _ReadExtensions:= ReadExtensions;
end;

procedure ActivateRenderingContext(DC: HDC; RC: HGLRC);

var
  PixelFormat: Integer;

begin
  Assert((DC <> 0), 'ActivateRenderingContext: DC must not be 0');
  Assert((RC <> 0), 'ActivateRenderingContext: RC must not be 0');
  if vRCRefCount = 0 then
  begin
    // The extension function addresses are unique for each pixel format. All rendering
    // contexts of a given pixel format share the same extension function addresses.
    if not wglMakeCurrent(DC, RC) then
      raise Exception.Create(e_Abort,Format('wglMakeCurrent failed: DC=%d, RC=%d', [DC, RC]));

    vCurrentDC := DC;
    vCurrentRC := RC;
    Inc(vRCRefCount);
    PixelFormat := GetPixelFormat(DC);
    if PixelFormat <> LastPixelFormat then
      begin
        CheckedExtensions:=[];
        ReadImplementationProperties;
        _ReadExtensions;
        LastPixelFormat:=PixelFormat;
      end;
  end
  else
    begin
      Assert((vCurrentDC = DC) and (vCurrentRC = RC), 'ActivateRenderingContext: incoherent DC/RC pair');
      Inc(vRCRefCount);
    end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure DeactivateRenderingContext;

begin
  Assert(vRCRefCount > 0, 'DeactivateRenderingContext: unbalanced activations');
  if vRCRefCount > 0 then
    Dec(vRCRefCount);

  if vRCRefCount = 0 then
  begin
    if not wglMakeCurrent(0, 0) then
      raise Exception.Create(e_Abort,'DeactivateRenderingContext: wglMakeCurrent failed');

    vCurrentDC := 0;
    vCurrentRC := 0;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure DestroyRenderingContext(RC: HGLRC);

begin
  Assert((vRCRefCount = 0), 'DestroyRenderingContext: unbalanced activations');
  if not wglDeleteContext(RC) then
    raise Exception.Create(e_Abort,'DestroyRenderingContext: wglDeleteContext failed');
end;

//----------------------------------------------------------------------------------------------------------------------

function CurrentRenderingContextDC: HDC;

begin
  Result := vCurrentDC;
end;

//----------------------------------------------------------------------------------------------------------------------

function CurrentRC: HGLRC;

begin
  Result := vCurrentRC;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure CloseOpenGL;

begin
  if GLHandle <> 0 then
  begin
    FreeLibrary(GLHandle);
    GLHandle := 0;
  end;
  if GLUHandle <> 0 then
  begin
    FreeLibrary(GLUHandle);
    GLUHandle := 0;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function InitOpenGL: Boolean;

begin
  if (GLHandle = 0) or (GLUHandle = 0) then
    Result := InitOpenGLFromLibrary('OpenGL32.DLL', 'GLU32.DLL')
  else
    Result := True;
end;

//----------------------------------------------------------------------------------------------------------------------

function InitOpenGLFromLibrary(GL_Name, GLU_Name: String): Boolean;

begin
  Result := False;
  CloseOpenGL;
  GLHandle := LoadLibrary(PChar(GL_Name));
  GLUHandle := LoadLibrary(PChar(GLU_Name));
  if (GLHandle <> 0) and (GLUHandle <> 0) then
  begin
//    PreLoadGLProcAddresses;
    Result := True;
  end
  else
  begin
    if GLHandle <> 0 then
      FreeLibrary(GLHandle);
    if GLUHandle <> 0 then
      FreeLibrary(GLUHandle);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function IsOpenGLInitialized: Boolean;

begin
  Result := GLHandle <> 0;
end;

//----------------------------------------------------------------------------------------------------------------------

initialization
  Set8087CW($133F);
finalization
  CloseOpenGL;
  // we don't need to reset the FPU control word as the previous set call is process specific
end.
