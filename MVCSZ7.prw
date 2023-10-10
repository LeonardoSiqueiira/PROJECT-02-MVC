#INCLUDE 'Protheus.ch'
#INCLUDE 'FwMvcDef.ch'

/*/{Protheus.doc} User Function MVCSZ7
    Fun��o principal para a constru��o de tela de Requisi��o de Compras
    @type  Function
    @author Leonardo Siqueira
    @since 10/10/2023
    @version 20231010
    (examples)
    @see https://tdn.totvs.com.br/pages/releaseview.action?pageId=28574107
    /*/

User Function MVCSZ7()
Local aArea                     := GetArea()
Local oBrowse                   := FwmBrowse():New()          // FARA O INSTANCIAMENTO DA CLASSE FWMBROWSE

oBrowse:SetAlias("SZ7")
oBrowse:SetDescription("Requisi��o de Compras")


oBrowse:Activate(aArea)

Return
