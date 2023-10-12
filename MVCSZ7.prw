#INCLUDE 'PROTHEUS.ch'
#INCLUDE 'FWMVCDEF.ch'

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
Local aArea                        := GetArea()
Local oBrowseSZ7
oBrowseSZ7                         := FWMBROWSE():New()          // FARA O INSTANCIAMENTO DA CLASSE FWMBROWSE

oBrowseSZ7:SetAlias("SZ7")
oBrowseSZ7:SetDescription("Requisi��o de Compras")

oBrowseSZ7:ACTIVATE()
RestArea(aArea)

Return


Static Function MenuDef()
Local aRotina                    := FwMvcMenu("MVCSZ7")


Return aRotina


// STATIC FUNCITON RESPONSAVEL PELO MODELO DE DADOS
Static Function ModelDef()
Local oModel                     
Local oStCabec                   := FWFormModelStruct():New()                  // RESPONSAVEL PELA ESTRUTURA TEMPORARIA DO CABE�ALHO
Local oStItens                   := FWFormStruct(1, "SZ7")                     // RESPONSAVEL PELA ESTRUTURA DO ITEM

Local bVldCom                    := {|| u_GrvSZ7()}                            // CHAMADA DA USER FUNCTION QUE VALIDARA A INCLUS�O/EXCLUS�O E ALTERA��O

oModel                           := MPFormModel():New("MVCSZ7m",,,bVldCom,)               // OBJETVO PRINCIPAL DO DESENVOLVIMENTO MVC MOD 2, TRAZ AS CARACTERISTICAS DO DICIOMARIO DE DADOS



// CRIA��O DA TABELA TEMPORARIA QUE SERA USADA NO CABE�ALHO
oStCabec:AddTable("SZ7", {"Z7_FILIAL", "Z7_NUM", "Z7_ITEM"}, "Cabe�alho SZ7")

// CRIA��O DOS CAMPOS DA TABELA TEMPORARIA
oStCabec:AddField(;
"Filial",;
"Filial",;
"Z7_FILIAL",;
"C",;
TamSX3("Z7_FILIAL")[1],;
0,;
Nil,;
Nil,;
{},;
.T.,;
FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI, SZ7-> Z7_FILIAL,FWxFilial('SZ7'))"),;
.T.,;
.F.,;
.F.)

oStCabec:AddField(;
"Pedido",;
"Pedido",;
"Z7_NUM",;
"C",;
TamSX3("Z7_NUM")[1],;
0,;
Nil,;
Nil,;
{},;
.T.,;
FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI, SZ7-> Z7_NUM,'')"),;
.T.,;
.F.,;
.F.)

oStCabec:AddField(;
"Emissao",;
"Emissao",;
"Z7_EMISSAO",;
"D",;
TamSX3("Z7_EMISSAO")[1],;
0,;
Nil,;
Nil,;
{},;
.T.,;
FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI, SZ7-> Z7_EMISSAO, dDataBase)"),;
.T.,;
.F.,;
.F.)

oStCabec:AddField(;
"Fornecedor",;
"Fornecedor",;
"Z7_FORNE",;
"C",;
TamSX3("Z7_FORNE")[1],;
0,;
Nil,;
Nil,;
{},;
.T.,;
FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI, SZ7-> Z7_FORNE, '')"),;
.F.,;
.F.,;
.F.)

oStCabec:AddField(;
"LOJA",;
"LOJA",;
"Z7_LOJA",;
"C",;
TamSX3("Z7_LOJA")[1],;
0,;
Nil,;
Nil,;
{},;
.T.,;
FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI, SZ7-> Z7_LOJA, '')"),;
.F.,;
.F.,;
.F.)

oStCabec:AddField(;
"USER",;
"USER",;
"Z7_USER",;
"C",;
TamSX3("Z7_USER")[1],;
0,;
Nil,;
Nil,;
{},;
.T.,;
FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI, SZ7-> Z7_USER, __cuserid)"),;
.F.,;
.F.,;
.F.)

/* TRATANDO A ESTRUTURA DOS ITENS QUE SER�O UTILIZADOS NO GRID DA APLICA��O
 MODIFICANDO INICIALIZADORES PADR�O PARA N�O OCORRER MSG DE COLUNA VAZIA */

oStItens:SetProperty("Z7_NUM",      MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"*"') )
oStItens:SetProperty("Z7_USER",     MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '__cUserId') ) // TRAZ O USUARIO AUTOMATICO
oStItens:SetProperty("Z7_FORNE",    MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"*"') )
oStItens:SetProperty("Z7_LOJA",     MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"*"') )
oStItens:SetProperty("Z7_EMISSAO",  MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, 'dDataBase') )  // TRAZ A DATA AUTOMATICA

/* REALIZANDO UNI�O DAS ESTRUTURAS, VINCULANDO CABE�ALHO COM ITENS 
   E ESTRUTURAS DE DADOS DOS ITENS AO MODELO
*/

oModel:AddFields("SZ7MASTER",,oStCabec)                 //VINCULA��O COM O oSTCABEC( CABE�ALHO E ITENS TEMPORARIOS )
oModel:AddGrid("SZ7DETAIL", "SZ7MASTER", oStItens,,,,,)
// SETANDO A RELA�AO ENTRE CABE�ALHO E ITENS, DIZENDO QUAL CAMPO O GRID ESTA VINCULADO AO CABE�ALHO
oModel:SetRelation("SZ7DETAIL",{{"Z7_FILIAL", "'Iif(!INCLUI, SZ7-> Z7_FILIAL,FWxFilial('SZ7'))'"},{"Z7_NUM", "SZ7 -> Z7_NUM"}}, SZ7 -> (IndexKey(1)))                                    

// SETO A CHAVE PRIMARIA
oModel:SetPrimaryKey({})

oModel:GetModel("SZ7DETAIL"):SetUniqueLine({"Z7_ITEM"})  // O OBJETIVO � QUE ESSE CAMPO N�O SE REPITA


// SETAMOS A DESCRI��O QUE APARECER� NO GRID DE ITENS E CABE�ALHO
oModel:GetModel("SZ7MASTER"):SetDescription("Cabe�alho Requisi��o de Compras")
oModel:GetModel("SZ7DETAIL"):SetDescription("Itens Requisi��o de Compras")

// FINALIZANDO A FUN��O MODEL
oModel:GetModel("SZ7DETAIL"):SetUseOldGrid(.T.)        // FINALIZO SETANDO O MODELO ANTIGO DE GRID, PEGANDO O AHEADER E ACOLS


Return oModel

// OBJETO DE VISUALIZA��O DO MVC
Static Function ViewDef()
Local oView                     := NIL

// REALIZO O LOAD DO MODEL REFERENTE A FUN��O MVCSZ7
Local oModel                    := FwLoadModel("MVCSZ7")        

Local oStCabec                  := FWFORMVIEWSTRUCT():New()     // RESPONSAVEL POR MONTAR A ESTRUTURA TEMPORARIA DO CABE�ALHO DA VIEW
Local oStItens                  := FWFormStruct(2,"SZ7")       // RESPONSAVEL POR MONTAR A PARTE DE ESTRUTURA DOS ITENS/GRID


// CRIANDO DENTRO DA ESTRUTURA DA VIEW OS CAMPOS DO CABE�ALHO
oStCabec:AddField(;
"Z7_NUM",;
"01",;
"Pedido",;
X3Descric("Z7_NUM"),;
Nil,;
"C",;
X3Picture("Z7_NUM"),;
Nil,;
Nil,;
Iif(INCLUI, .T., .F.),;
Nil,;
Nil,;
Nil,;
Nil,;
Nil,;
Nil,;
Nil,;
Nil)

oStCabec:AddField(;
"Z7_EMISSAO",;
"02",;
"Emissao",;
X3Descric("Z7_EMISSAO"),;
Nil,;
"D",;
X3Picture("Z7_EMISSAO"),;
Nil,;
Nil,;
Iif(INCLUI, .T., .F.),;
Nil,;
Nil,;
Nil,;
Nil,;
Nil,;
Nil,;
Nil,;
Nil)

oStCabec:AddField(;
"Z7_FORNE",;
"03",;
"Fornecedor",;
X3Descric("Z7_FORNE"),;
Nil,;
"C",;
X3Picture("Z7_FORNE"),;
Nil,;
"SF2",;
Iif(INCLUI, .T., .F.),;
Nil,;
Nil,;
Nil,;
Nil,;
Nil,;
Nil,;
Nil,;
Nil)

oStCabec:AddField(;
"Z7_LOJA",;
"04",;
"Loja",;
X3Descric("Z7_LOJA"),;
Nil,;
"C",;
X3Picture("Z7_LOJA"),;
Nil,;
Nil,;
Iif(INCLUI, .T., .F.),;
Nil,;
Nil,;
Nil,;
Nil,;
Nil,;
Nil,;
Nil,;
Nil,;
)

oStCabec:AddField(;
"Z7_USER",;
"05",;
"User",;
X3Descric("Z7_USER"),;
Nil,;
"C",;
X3Picture("Z7_USER"),;
Nil,;
Nil,;
.F.,;
Nil,;
Nil,;
Nil,;
Nil,;
Nil,;
Nil,;
Nil,;
Nil,;
)

oStItens:RemoveField("Z7_NUM")
oStItens:RemoveField("Z7_EMISSAO")
oStItens:RemoveField("Z7_FORNE")
oStItens:RemoveField("Z7_LOJA")
oStItens:RemoveField("Z7_USER")

// AMARRA��O DAS ESTRUTURAS DE DADOS MONTADAS ACIMA COM O OBJETO VIEW, E PASSAMOS PARA A APLICA��O AS CARACTERISTICAS VISUAIS

// INSTANCIO A CLASSE FWFORM VIEW E PASSO PARA O OBJETO O MODELO DE DADOS QUE VAI ATRELAR A ELE. ( MODELO + VISUALIZA��O )
oView                           := FwFormView():New()
oView:SetModel(oModel)

// MONTO A ESTRUTURA DE VISUALIZA��O DO MASTER E DO DETALHE
oView:AddField("VIEW_SZ7M",oStCabec,"SZ7MASTER") // CABE�ALHO
oView:AddGrid("VIEW_SZ7D", oStItens, "SZ7DETAIL") // ITENS/GRID

// CRIANDO TELA

oView:CreateHorizontalBox("CABEC",30)
oView:CreateHorizontalBox("GRID", 60)

// DIZENDO PARA OONDE CADA VIEW CRIADA .. ASSOCIANDO O VIEW A CADA BOX CRIADO
oView:SetOwnerView("VIEW_SZ7M", "CABEC")
oView:SetOwnerView("VIEW_SZ7D", "GRID")

// ATIVAR O TITULO DE CADA VIEW CRIADA
oView:EnableTitleView("VIEW_SZ7M", "Cabe�alho Requisi��o de Compras")
oView:EnableTitleView("VIEW_SZ7D", "Itens Requisi��o de Compras")

oView:SetCloseOnOk({|| .T.}) // UTILIZADO PARA VERIFCAR SE A JANELA DEVE OU N�O SER FECHADA APOS O OK

Return oView


User Function GrvSZ7()

Local aArea                     := GetArea()
Local oModel                    := FwModelActive()                  // CAPTURO O MODELO ATIVO QUE ESTA SENDO MANIPULADO

// CRIAR MODELO DE DADOS MASTER/CABE�ALHO
Local oModelCabe                := oModel:GetModel("SZ7MASTER")     // CARREGANDO MODELO DO CABE�ALHO
Local oModelItem                := oModel:getModel("SZ7DETAIL")     // CARREGANDO MODELO DOS ITENS


RestArea(aArea)


Return lRet
