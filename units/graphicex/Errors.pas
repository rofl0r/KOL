unit Errors;

interface

var
  ErrorMsg: array[1..21] of string = (
{01}  'Cannot load image. Invalid or unexpected %s image format.',
{02}  'Invalid color format in %s file.',
{03}  'Stream read error in %s file.',
{04}  'Cannot load image. Unsupported %s image format.',
{05}  'Cannot load image. %s not supported for %s files.',
{06}  'Cannot load image. CRC error found in %s file.',
{07}  'Cannot load image. Compression error found in %s file.',
{08}  'Cannot load image. Extra compressed data found in %s file.',
{09}  'Cannot load image. Palette in %s file is invalid.',
{10}  'Cannot load PNG image. Unexpected but critical chunk detected.',
      // features (usually used together with unsupported feature string)
{11}  'The compression scheme is',
{12}  'Image formats other than RGB and RGBA are',
{13}  'File versions other than 3 or 4 are',
      // color manager error messages
{14}  'Conversion between indexed and non-indexed pixel formats is not supported.',
{15}  'Color conversion failed. Could not find a proper method.',
{16}  'Color depth is invalid. Bits per sample must be 1,2,4,8 or 16.',
{17}  'Sample count per pixel does not correspond to the given color scheme.',
{18}  'Subsampling value is invalid. Allowed are 1,2 and 4.',
{19}  'Vertical subsampling value must be <= horizontal subsampling value.',
      // compression errors
{20}  'LZ77 decompression error.',
      // miscellaneous
{21}  'Warning');

implementation

end.

