<#
.SYNOPSIS
ビルドしたバイナリをリモート環境に転送します。
.DESCRIPTION
ビルドしたバイナリをリモート環境に転送します。

.INPUTS
None. This script does not correspond.
.OUTPUTS
System.Int32
If success, this script returns 0, otherwise -1.

.EXAMPLE
.\sync_binaries.ps1 -serverName hoge
hoge サーバへバイナリを転送

.NOTES
None.
#>

[CmdletBinding(
  SupportsShouldProcess=$true,
  ConfirmImpact="Medium"
)]
Param(
  $serverName = ""
)

# サーバ名は必須
if ($serverName -eq "") {
  Write-Error "Please input server name."
  exit -1
}

# ディレクトリ情報の取得
$SCRIPT_DIR = (Split-Path -Parent $MyInvocation.MyCommand.Path)
$PROJ_DIR = (Resolve-Path (Join-Path $SCRIPT_DIR ..)).Path

# 入出力先の設定
$BIN_DIR = "build/bin/Release"
$SRC_DIR = (Join-Path $PROJ_DIR $BIN_DIR)

$DST_REDUNDANT_STR_LEN = (Resolve-Path $PROJ_DIR/../../../..).Path.Length + 1
$DST_PROJ_DIR = $PROJ_DIR.SubString($DST_REDUNDANT_STR_LEN, $PROJ_DIR.Length - $DST_REDUNDANT_STR_LEN)
$DST_DIR = "//$serverName/$DST_PROJ_DIR/$BIN_DIR"

# コピー
robocopy $SRC_DIR $DST_DIR /MIR

exit 0

