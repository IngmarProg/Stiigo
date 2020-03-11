{ RxMDI unit

  Copyright (C) 2005-2018 Lagunov Aleksey alexs75@yandex.ru and Typhon team
  original conception from rx library for Delphi (c)

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version with the following modification:

  As a special exception, the copyright holders of this library give you
  permission to link this library with independent modules to produce an
  executable, regardless of the license terms of these independent modules,and
  to copy and distribute the resulting executable under terms of your choice,
  provided that you also meet, for each linked independent module, the terms
  and conditions of the license of that module. An independent module is a
  module which is not derived from or based on this library. If you modify
  this library, you may extend this exception to your version of the library,
  but you are not obligated to do so. If you do not wish to do so, delete this
  exception statement from your version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
}

{ TODO : 1. Реализовать отображение открытых окон в элементе меню - с переключением на выбранное окно }
{ TODO : 2. В элементе меню отображать пункт для открытия диалогового окна со списком всех открытых окон }

unit RxMDI;

{$I rx.inc}

interface

uses
  Classes, SysUtils, Forms, Buttons, Menus, ExtCtrls, Graphics, Controls;

type
  TRxMDITaskOption = (rxtoMidleClickClose, rxtoAskCloseAll);
  TRxMDITaskOptions = set of TRxMDITaskOption;

  TRxMDIPanelOption = (rxpoCloseF4, rxpoSwithByTab);
  TRxMDIPanelOptions = set of TRxMDIPanelOption;

  TRxMDIPanel = class;
  TRxMDITasks = class;

  TRxMDIPanelChangeCurrentChild = procedure (Sender:TRxMDIPanel; AForm:TForm) of object;

  { TRxMDIButton }

  TRxMDIButton = class(TSpeedButton)
  private
    FNavForm: TForm;
    FActiveControl:TWinControl;
    FNavPanel:TRxMDITasks;
    procedure SetRxMDIForm(AValue: TForm);
    procedure DoCreateMenuItems;

    procedure DoCloseMenu(Sender: TObject);
    procedure DoCloseAllMenu(Sender: TObject);
    procedure DoCloseAllExcepThisMenu(Sender: TObject);
    procedure DoActivateMenu(Sender: TObject);
    procedure DoCreateButtonImage;
  private
    FMenu:TPopupMenu;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor CreateButton(AOwner:TRxMDITasks; AForm:TForm);
    procedure Click; override; // make Click public
    procedure UpdateCaption;
    property NavForm:TForm read FNavForm write SeTRxMDIForm;
  end;

  { TRxMDITasks }

  TRxMDITasks = class(TCustomPanel)
  private
    FBtnScrollLeft:TSpeedButton;
    FBtnScrollRigth:TSpeedButton;
    FMainPanel: TRxMDIPanel;
    FOptions: TRxMDITaskOptions;
    function GetFlatButton: boolean;
    procedure SetFlatButton(AValue: boolean);
    procedure UpdateScrollBtnStatus;
    procedure ScrollLeftExecute(Sender: TObject);
    procedure ScrollRigthExecute(Sender: TObject);
    procedure ShowHiddenBtnOnResize;
    procedure ChildWindowsShowLast;
    procedure DoCloseAll(AIgnoreBtn:TRxMDIButton);
    procedure ShowMDIButton(Btn:TRxMDIButton);
  protected
    procedure Paint; override;
    procedure Resize; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddButton(Btn:TRxMDIButton);
    procedure ShowWindow(F:TForm);
    property MainPanel:TRxMDIPanel read FMainPanel{ write FMainPanel};
    procedure SelectNext;
    procedure SelectPrior;
    procedure UpdateMDICaptions;
  published
    property Align;
    property ShowHint;
    property Color;
    property ParentShowHint;
    property FlatButton:boolean read GetFlatButton write SetFlatButton;
    property Options:TRxMDITaskOptions read FOptions write FOptions;
  end;

  { TRxMDICloseButton }

  TRxMDICloseButton = class(TCustomSpeedButton)
  private
    FInfoLabel:TBoundLabel;
    FLabelSpacing:integer;
    FMDIPanel:TRxMDIPanel;
    FShowInfoLabel: boolean;
    procedure SetShowInfoLabel(AValue: boolean);
  protected
    procedure SetParent(AParent: TWinControl); override;
    procedure Loaded; override;
    procedure DoPositionLabel;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure CreateInternalLabel;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property Anchors;
    property Glyph;
    property Flat;
    property ShowInfoLabel:boolean read FShowInfoLabel write SetShowInfoLabel default true;
  end;

  { TRxMDIPanel }

  TRxMDIPanel = class(TCustomPanel)
  private
    FCurrentChildWindow: TForm;
    FCloseButton: TRxMDICloseButton;
    FHideCloseButton: boolean;
    FOnChangeCurrentChild: TRxMDIPanelChangeCurrentChild;
    FOptions: TRxMDIPanelOptions;
    FTaskPanel: TRxMDITasks;
    FWindowMenu: TMenuItem;
    FWindowMenuSeparator1: TMenuItem;
    FWindowMenuSeparator2: TMenuItem;
    FWindowMenuDialogBox: TMenuItem;
    procedure SetCurrentChildWindow(AValue: TForm);
    procedure navCloseButtonClick(Sender: TObject);
    procedure SetHideCloseButton(AValue: boolean);
    procedure SetRxMDICloseButton(AValue: TRxMDICloseButton);
    procedure SetTaskPanel(AValue: TRxMDITasks);
    function MDIButtonByForm(AForm:TForm):TRxMDIButton;
    procedure HideCurrentWindow;
    procedure ScreenEventRemoveForm(Sender: TObject; Form: TCustomForm);
    procedure DoOnChangeCurrentChild(AForm:TForm);
    procedure DoKeyDownHandler(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RefreshMDIMenu;
    procedure ClearMDIMenu;
    procedure ClearMDIMenuSystemItems;
    procedure DoMDIMenuClick(Sender: TObject);
    procedure SetWindowMenu(AValue: TMenuItem);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure ShowWindow(F:TForm);

    procedure ChildWindowsAdd(F:TForm);
    procedure ChildWindowsCreate(var AForm; FC:TFormClass);
    procedure ChildWindowsUpdateCaption(F:TForm);
    procedure CloseAll;

    property CurrentChildWindow:TForm read FCurrentChildWindow write SetCurrentChildWindow;
  published
    property CloseButton:TRxMDICloseButton read FCloseButton write SetRxMDICloseButton;
    property TaskPanel:TRxMDITasks read FTaskPanel write SetTaskPanel;

    property Align;
    property BevelInner;
    property BevelOuter;
    property ShowHint;
    property ParentShowHint;
    property Options:TRxMDIPanelOptions read FOptions write FOptions;
    property HideCloseButton:boolean read FHideCloseButton write SetHideCloseButton;
    property OnChangeCurrentChild:TRxMDIPanelChangeCurrentChild read FOnChangeCurrentChild write FOnChangeCurrentChild;
    property WindowMenu: TMenuItem read FWindowMenu write SetWindowMenu;
  end;

implementation
uses LResources, rxlclutils, rxconst, LCLType, Dialogs;


{ TRxMDICloseButton }

procedure TRxMDICloseButton.SetShowInfoLabel(AValue: boolean);
begin
  if FShowInfoLabel=AValue then Exit;
  FShowInfoLabel:=AValue;
  if Assigned(FInfoLabel) then
    FInfoLabel.Visible:=FShowInfoLabel;
end;

procedure TRxMDICloseButton.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  DoPositionLabel;
end;

procedure TRxMDICloseButton.Loaded;
begin
  inherited Loaded;
  DoPositionLabel;
end;

procedure TRxMDICloseButton.DoPositionLabel;
begin
  if FInfoLabel = nil then exit;
  if Parent<>nil then
    Parent.DisableAlign;
  //DebugLn(['TCustomLabeledEdit.DoPositionLabel ']);
  FInfoLabel.Parent := Parent;
  FInfoLabel.Visible := Visible and FShowInfoLabel;
{  case FLabelPosition of
    lpAbove:
      begin
        FInfoLabel.AnchorParallel(akLeft,0,Self);
        FInfoLabel.AnchorToCompanion(akBottom,FLabelSpacing,Self);
      end;
    lpBelow:
      begin
        FInfoLabel.AnchorParallel(akLeft,0,Self);
        FInfoLabel.AnchorToCompanion(akTop,FLabelSpacing,Self);
      end;
    lpLeft :
      begin}
        FInfoLabel.AnchorToCompanion(akRight,FLabelSpacing,Self);
        FInfoLabel.AnchorVerticalCenterTo(Self);
{      end;
    lpRight:
      begin
        FInfoLabel.AnchorToCompanion(akLeft,FLabelSpacing,Self);
        FInfoLabel.AnchorVerticalCenterTo(Self);
      end;
  end;}
  if Parent<>nil then
    Parent.EnableAlign;
end;

procedure TRxMDICloseButton.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FInfoLabel) and (Operation = opRemove) then
    FInfoLabel := nil
  else
  if (AComponent = FMDIPanel) and (Operation = opRemove) then
  begin
    FMDIPanel:=nil;
    OnClick:=nil;
  end
end;

procedure TRxMDICloseButton.CreateInternalLabel;
begin
  if FInfoLabel<>nil then exit;
  FInfoLabel := TBoundLabel.Create(Self);
  FInfoLabel.ControlStyle := FInfoLabel.ControlStyle + [csNoDesignSelectable];
  FInfoLabel.Visible:=FShowInfoLabel;
end;

constructor TRxMDICloseButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLabelSpacing := 6;
  FShowInfoLabel:=true;
  CreateInternalLabel;
  RxAssignBitmap(Glyph, 'RxMDICloseIcon');
end;

{ TRxMDIPanel }

procedure TRxMDIPanel.SetCurrentChildWindow(AValue: TForm);
begin
  FCurrentChildWindow:=AValue;
  if Assigned(FCloseButton) then
  begin
    FCloseButton.Enabled:=Assigned(FCurrentChildWindow);
    if FHideCloseButton then
      FCloseButton.Visible:=FCloseButton.Enabled;

    if FCloseButton.Enabled then
      FCloseButton.FInfoLabel.Caption:=FCurrentChildWindow.Caption
    else
      FCloseButton.FInfoLabel.Caption:='';
  end;

  if Assigned(TaskPanel) then
    TaskPanel.Visible:=Assigned(FCurrentChildWindow);
end;

procedure TRxMDIPanel.navCloseButtonClick(Sender: TObject);
begin
  if Assigned(FCurrentChildWindow) then
  begin
    if not (csDestroying in FCurrentChildWindow.ComponentState) then
      FCurrentChildWindow.Close
  end;
end;

procedure TRxMDIPanel.SetHideCloseButton(AValue: boolean);
begin
  if FHideCloseButton=AValue then Exit;
  FHideCloseButton:=AValue;

  if Assigned(FCloseButton) then
    if FHideCloseButton then
      FCloseButton.Visible:=FCloseButton.Enabled
    else
      FCloseButton.Visible:=true;

end;

procedure TRxMDIPanel.SetRxMDICloseButton(AValue: TRxMDICloseButton);
begin
  if FCloseButton=AValue then Exit;
  if Assigned(FCloseButton) then
  begin
    FCloseButton.OnClick:=nil;
    FCloseButton.FMDIPanel:=nil;
  end;

  FCloseButton:=AValue;

  if Assigned(FCloseButton) then
  begin
    FCloseButton.OnClick:=@navCloseButtonClick;
    FCloseButton.FMDIPanel:=Self;
  end;
end;

procedure TRxMDIPanel.SetTaskPanel(AValue: TRxMDITasks);
begin
  if FTaskPanel=AValue then Exit;
  FTaskPanel:=AValue;
  if Assigned(FTaskPanel) then
    FTaskPanel.FMainPanel:=Self;
end;

function TRxMDIPanel.MDIButtonByForm(AForm: TForm): TRxMDIButton;
var
  i:integer;
begin
  Result:=nil;
  if not Assigned(FTaskPanel) then
    exit;
  for i:=0 to FTaskPanel.ComponentCount -1 do
  begin
    if (FTaskPanel.Components[i] is TRxMDIButton) and (TRxMDIButton(FTaskPanel.Components[i]).NavForm = AForm) then
    begin
      Result:=TRxMDIButton(FTaskPanel.Components[i]);
      exit;
    end;
  end;
end;

procedure TRxMDIPanel.HideCurrentWindow;
var
  MB:TRxMDIButton;
begin
  if Assigned(FCurrentChildWindow) and (FCurrentChildWindow.Visible) then
  begin
    MB:=MDIButtonByForm(FCurrentChildWindow);
    if Assigned(MB) then
      MB.FActiveControl:=Application.MainForm.ActiveControl;
    FCurrentChildWindow.Hide;
  end;
end;

procedure TRxMDIPanel.ScreenEventRemoveForm(Sender: TObject; Form: TCustomForm);
var
  i: Integer;
begin
  if Assigned(FTaskPanel) then
  begin
    for i:=0 to FTaskPanel.ComponentCount-1 do
    begin;
      if (FTaskPanel.Components[i] is TRxMDIButton) and (TRxMDIButton(FTaskPanel.Components[i]).NavForm = Form) then
        TRxMDIButton(FTaskPanel.Components[i]).FActiveControl:=nil;
    end;
  end;
end;

procedure TRxMDIPanel.DoOnChangeCurrentChild(AForm: TForm);
begin
  if Assigned(FOnChangeCurrentChild) then
    FOnChangeCurrentChild(Self, AForm);
end;

procedure TRxMDIPanel.Notification(AComponent: TComponent; Operation: TOperation
  );
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FCloseButton) and (Operation = opRemove) then
    FCloseButton := nil
  else
  if (AComponent = FTaskPanel) and (Operation = opRemove) then
    FTaskPanel:=nil
  else
  if (AComponent = FWindowMenuSeparator1) and (Operation = opRemove) then
    FWindowMenuSeparator1:=nil;
end;

procedure TRxMDIPanel.Loaded;
begin
  inherited Loaded;
  CurrentChildWindow:=nil;
end;

procedure TRxMDIPanel.DoKeyDownHandler(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) then
  begin
    if (rxpoCloseF4 in Options) and (Key = VK_F4) then
      navCloseButtonClick(nil)
    else
    if (rxpoSwithByTab in Options) and (Key = VK_TAB) and Assigned(FTaskPanel) then
    begin
      if ssShift in Shift then
        FTaskPanel.SelectPrior
      else
        FTaskPanel.SelectNext;
    end;
  end;
end;

procedure TRxMDIPanel.RefreshMDIMenu;

function GetNextMenuItem(var K:Integer):TMenuItem;
begin
  Result:=nil;
  while K<FWindowMenu.Count-1 do
  begin
    Inc(K);
    Result:=FWindowMenu.Items[K];
    if Result.OnClick = @DoMDIMenuClick then
      Exit;
  end;

  if not Assigned(FWindowMenuSeparator1) then
  begin
    Inc(K);
    FWindowMenuSeparator1:=TMenuItem.Create(FWindowMenu.Owner);
    FWindowMenu.Add(FWindowMenuSeparator1);
    FWindowMenuSeparator1.Caption:='-';
  end;

  Inc(K);
  Result:=TMenuItem.Create(FWindowMenu.Owner);
  FWindowMenu.Add(Result);
  Result.OnClick:=@DoMDIMenuClick;
end;

var
  M: TMenuItem;
  B: TRxMDIButton;
  K, i, CntItem: Integer;
begin
  if (not Assigned(FWindowMenu)) or (not Assigned(FTaskPanel)) then Exit;

  K:=-1;
  CntItem:=0;
  for i:=0 to FTaskPanel.ComponentCount-1 do
  begin
    if (FTaskPanel.Components[i] is TRxMDIButton) then
    begin
      B:=TRxMDIButton(FTaskPanel.Components[i]);
      M:=GetNextMenuItem(K);
      M.Caption:=B.Caption;
      M.Checked:=B.Down;
      M.Tag:=IntPtr(B);
      Inc(CntItem);
    end;
  end;

  if K < FWindowMenu.Count-1 then
  begin
    for i:=FWindowMenu.Count-1 downto K+1 do
    begin
      M:=FWindowMenu.Items[i];
      if M.OnClick = @DoMDIMenuClick then
        M.Free;
    end
  end;

  if CntItem = 0 then
    ClearMDIMenuSystemItems;
end;

procedure TRxMDIPanel.ClearMDIMenu;
var
  i: Integer;
  M: TMenuItem;
begin
  if not Assigned(FWindowMenu) then Exit;
  for i:=FWindowMenu.Count-1 downto 0 do
  begin
    M:=FWindowMenu.Items[i];
    if M.OnClick = @DoMDIMenuClick then
      M.Free;
  end;

  ClearMDIMenuSystemItems;
end;

procedure TRxMDIPanel.ClearMDIMenuSystemItems;
begin
  if Assigned(FWindowMenuSeparator1) then
    FreeAndNil(FWindowMenuSeparator1);
  if Assigned(FWindowMenuSeparator2) then
    FreeAndNil(FWindowMenuSeparator2);
  if Assigned(FWindowMenuDialogBox) then
    FreeAndNil(FWindowMenuDialogBox);
end;

procedure TRxMDIPanel.DoMDIMenuClick(Sender: TObject);
var
  B: TRxMDIButton;
begin
  if Sender is TMenuItem then
  begin
    B:=TRxMDIButton(PtrInt(TMenuItem(Sender).Tag));
    if Assigned(B) then
      B.Click;
  end;//
end;

procedure TRxMDIPanel.SetWindowMenu(AValue: TMenuItem);
begin
  if FWindowMenu=AValue then Exit;
  if Assigned(FWindowMenu) then
    ClearMDIMenu;
  FWindowMenu:=AValue;
  RefreshMDIMenu;
end;

constructor TRxMDIPanel.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  Caption:='';
  Align:=alClient;
  BevelOuter:=bvLowered;
  FOptions:=[];

  Screen.AddHandlerRemoveForm(@ScreenEventRemoveForm);
  Application.AddOnKeyDownBeforeHandler(@DoKeyDownHandler);
end;

destructor TRxMDIPanel.Destroy;
begin
  Application.RemoveOnKeyDownBeforeHandler(@DoKeyDownHandler);
  Screen.RemoveHandlerRemoveForm(@ScreenEventRemoveForm);
  inherited Destroy;
end;

procedure TRxMDIPanel.ShowWindow(F: TForm);
begin
  TaskPanel.ShowWindow(F);
end;

procedure TRxMDIPanel.ChildWindowsAdd(F: TForm);
var
  B:TRxMDIButton;
begin
  Assert(Assigned(TaskPanel), sErrorLinkedTaskPanel);
  HideCurrentWindow;
  F.BorderStyle:=bsNone;
  F.Align:=alClient;
  F.Parent:=Self;
  F.Visible:=true;
  F.BringToFront;

  if Assigned(Owner) and (Owner is TForm) then
    TForm(Owner).ActiveControl:=F;

  B:=TRxMDIButton.CreateButton(TaskPanel, F);
  DoOnChangeCurrentChild(F);
  RefreshMDIMenu;
end;

procedure TRxMDIPanel.ChildWindowsCreate(var AForm; FC: TFormClass);
var
  FForm:TForm absolute AForm;
begin
  if not Assigned(FForm) then
  begin
    HideCurrentWindow;
    FForm:=FC.Create(Self);
    ChildWindowsAdd(FForm);
  end
  else
  begin
    ShowWindow(FForm);
    DoOnChangeCurrentChild(FForm);
  end;

end;

procedure TRxMDIPanel.ChildWindowsUpdateCaption(F: TForm);
var
  i:integer;
//  B:TRxMDIButton;
  C: TComponent;
begin
  if (FCurrentChildWindow = F) and Assigned(FCloseButton) and FCloseButton.Enabled then
    FCloseButton.FInfoLabel.Caption:=F.Caption;

  for i:=0 to TaskPanel.ComponentCount -1 do
  begin
    C:=TaskPanel.Components[i];
    if C is TRxMDIButton then
      if TRxMDIButton(C).NavForm = F then
      begin
        TRxMDIButton(C).UpdateCaption;
        exit;
      end;
  end;
end;

procedure TRxMDIPanel.CloseAll;
begin
  if Assigned(FTaskPanel) then
    FTaskPanel.DoCloseAll(nil);
end;


{ TRxMDITasks }

procedure TRxMDITasks.UpdateScrollBtnStatus;
var
  i, W:Integer;
  B:TRxMDIButton;
begin
  W:=FBtnScrollLeft.Width + FBtnScrollRigth.Width;
  FBtnScrollLeft.Enabled:=false;
  for i:=0 to ComponentCount-1 do
  begin
    B:=TRxMDIButton(Components[i]);
    if not B.Visible then
      FBtnScrollLeft.Enabled:=true
    else
      W:=W+B.Width + 2;
  end;

  FBtnScrollRigth.Enabled:=W > Width;
end;

function TRxMDITasks.GetFlatButton: boolean;
begin
  Result:=FBtnScrollLeft.Flat;
end;

procedure TRxMDITasks.SetFlatButton(AValue: boolean);
var
  B: TComponent;
begin
  FBtnScrollLeft.Flat:=AValue;
  FBtnScrollRigth.Flat:=AValue;

  for B in Self do
    if (B is TRxMDIButton) then
      TRxMDIButton(B).Flat:=AValue;
end;

procedure TRxMDITasks.ScrollLeftExecute(Sender: TObject);
var
  i:Integer;
  B:TRxMDIButton;
begin
  for I:=ComponentCount-1 downto 0 do
  begin
    if (Components[i] is TRxMDIButton) then
    begin
      B:=TRxMDIButton(Components[i]);
      if not B.Visible then
      begin
        B.Visible:=true;
        B.Left:=FBtnScrollLeft.Width;
        break;
      end;
    end;
  end;

  UpdateScrollBtnStatus;
  Invalidate;
end;

procedure TRxMDITasks.ScrollRigthExecute(Sender: TObject);
var
  i:Integer;
  B:TRxMDIButton;
begin
  for i:=0 to ComponentCount - 1 do
  begin
    if (Components[i] is TRxMDIButton) then
    begin
      B:=TRxMDIButton(Components[i]);
      if B.Visible then
      begin
        B.Visible:=false;
        break;
      end;
    end;
  end;

  UpdateScrollBtnStatus;
  Invalidate;
end;

procedure TRxMDITasks.ShowHiddenBtnOnResize;
begin

end;

procedure TRxMDITasks.ChildWindowsShowLast;
var
  CC:TControl;
  i:integer;
begin
  if (FMainPanel.ControlCount>1) and (not Application.Terminated) then
  begin
    CC:=FMainPanel.Controls[FMainPanel.ControlCount-2];
    if Assigned(CC) then
      ShowWindow(CC as TForm)
  end
  else
  begin
    FMainPanel.CurrentChildWindow:=nil;
    if not Application.Terminated then
      if Assigned(FMainPanel) then
        FMainPanel.DoOnChangeCurrentChild(nil);

  end;
//  Invalidate;
end;

procedure TRxMDITasks.DoCloseAll(AIgnoreBtn: TRxMDIButton);
var
  i:integer;
begin
  for i:=ComponentCount-1 downto 0 do
  begin
    if (Components[i] is TRxMDIButton) and (TRxMDIButton(Components[i]) <> AIgnoreBtn) then
      TRxMDIButton(Components[i]).DoCloseMenu(nil);
  end;
  if Assigned(AIgnoreBtn) then
    FMainPanel.CurrentChildWindow:=AIgnoreBtn.FNavForm;
end;

procedure TRxMDITasks.ShowMDIButton(Btn: TRxMDIButton);
var
  B: TRxMDIButton;
  i, W, K: Integer;
begin
  Exit;
  if (not Assigned(Btn)) or (Btn.Parent <> Self) then Exit;

  if not Btn.Visible then
  begin
    for i:=ComponentCount-1 downto 0 do
    begin
      if (Components[i] is TRxMDIButton) then
      begin
        B:=TRxMDIButton(Components[i]);
        if not B.Visible then
        begin
          B.Visible:=true;
          B.Left:=FBtnScrollLeft.Width;
          if B = Btn then
            break;
        end;
      end;
    end;
  end
  else
  begin
    W:=FBtnScrollLeft.Width;
    K:=Btn.ComponentIndex;
    for I:=0 to K do
    begin
      if (Components[i] is TRxMDIButton) then
      begin
        B:=TRxMDIButton(Components[i]);
        W:=W + B.Width;
      end;
    end;

    if W > Width then
    begin
      W:=Width - FBtnScrollLeft.Width;
      K:=0;
      for i:=Btn.ComponentIndex downto 0 do
      begin
        if (Components[i] is TRxMDIButton) then
        begin
          B:=TRxMDIButton(Components[i]);
          W:=W - B.Width;
          if W < 0 then
          begin
            K:=i;
            break;
          end;
        end;
      end;

      if K>0 then
      begin
        for i:=0 to K - 1 do
        begin
          if (Components[i] is TRxMDIButton) then
          begin
            B:=TRxMDIButton(Components[i]);
            B.Visible:=false;
          end;

        end;
      end;
    end;
  end;
end;

procedure TRxMDITasks.Paint;
var
  i:integer;
  H:integer;
  B:TRxMDIButton;
begin
  inherited Paint;
  Canvas.Pen.Color:=clBlack;
  H:=Height - 2;
  for i:=0 to ComponentCount - 1 do
  begin
    if (Components[i] is TRxMDIButton) then
    begin
      B:=TRxMDIButton(Components[i]);
      if (B.Visible) and (B.Left > B.Width) then
      begin
        Canvas.Pen.Color:=clBtnShadow;
        Canvas.Line(B.Left - 2, 2, B.Left - 2, H);
        Canvas.Pen.Color:=clWindow;
        Canvas.Line(B.Left - 1, 2, B.Left - 1, H);
      end;
    end;
  end;
end;

procedure TRxMDITasks.Resize;
begin
  inherited Resize;
  if Assigned(FBtnScrollLeft) and Assigned(FBtnScrollRigth) then
    UpdateScrollBtnStatus;
end;

procedure TRxMDITasks.Notification(AComponent: TComponent; Operation: TOperation
  );
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if (AComponent = FMainPanel) then
      FMainPanel := nil
    else
    if (AComponent is TRxMDIButton) then
      Invalidate;
  end;
end;

constructor TRxMDITasks.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FOptions:=[rxtoAskCloseAll, rxtoMidleClickClose];
  Caption:='';

  FBtnScrollLeft:=TSpeedButton.Create(Self);
  FBtnScrollLeft.Parent:=Self;
  FBtnScrollLeft.Align:=alLeft;
  FBtnScrollLeft.AnchorSide[akLeft].Control:=Self;
  FBtnScrollLeft.Anchors:=[akLeft, akTop, akBottom];
  FBtnScrollLeft.OnClick:=@ScrollLeftExecute;
  FBtnScrollLeft.Caption:='<';
  FBtnScrollLeft.ShowCaption:=true;
  FBtnScrollLeft.AutoSize:=true;
  FBtnScrollLeft.Flat:=true;
  FBtnScrollLeft.Transparent:=false;

  FBtnScrollRigth:=TSpeedButton.Create(Self);
  FBtnScrollRigth.Parent:=Self;
  FBtnScrollRigth.Align:=alRight;
  FBtnScrollRigth.Anchors:=[akRight, akTop, akBottom];
  FBtnScrollRigth.AnchorSide[akRight].Control:=Self;
  FBtnScrollRigth.OnClick:=@ScrollRigthExecute;
  FBtnScrollRigth.Caption:='>';
  FBtnScrollRigth.ShowCaption:=true;
  FBtnScrollRigth.AutoSize:=true;
  FBtnScrollRigth.Flat:=true;
  FBtnScrollRigth.Transparent:=false;

  Align:=alBottom;
  Height:=25;
end;

destructor TRxMDITasks.Destroy;
begin
  FBtnScrollRigth:=nil;
  FBtnScrollLeft:=nil;
  inherited Destroy;
end;

procedure TRxMDITasks.AddButton(Btn: TRxMDIButton);
begin
  Btn.Parent:=Self;
  Btn.Left:=Width-1;
  Btn.Down:=true;
  Btn.BorderSpacing.Left:=3;
  Btn.BorderSpacing.Right:=3;
  Btn.Flat:=FlatButton;

  FBtnScrollRigth.BringToFront;
  FBtnScrollLeft.BringToFront;

  UpdateScrollBtnStatus;
end;

procedure TRxMDITasks.ShowWindow(F: TForm);
var
  i:integer;
begin
  for i:=0 to ComponentCount -1 do
  begin
    if (Components[i] is TRxMDIButton) and (TRxMDIButton(Components[i]).NavForm = F) then
    begin
      TRxMDIButton(Components[i]).Click;
      TRxMDIButton(Components[i]).Visible:=true;
      exit;
    end;
  end;
end;

procedure TRxMDITasks.SelectNext;
var
  F: TForm;
  Ind, i: Integer;
  C: TControl;
begin
  if not Assigned(FMainPanel) then Exit;
  F:=FMainPanel.CurrentChildWindow;
  if not Assigned(F) then Exit;
  if FMainPanel.ControlCount = 1 then exit;
  Ind:=FMainPanel.GetControlIndex(F);

  for i:=Ind+1 to FMainPanel.ControlCount-1 do
  begin
    C:=FMainPanel.Controls[i];
    if C is TCustomForm then
    begin
      ShowWindow(TForm(C));
      Exit;
    end;
  end;

  for i:=0 to Ind - 1 do
  begin
    C:=FMainPanel.Controls[i];
    if C is TCustomForm then
    begin
      ShowWindow(TForm(C));
      Exit;
    end;
  end;
end;

procedure TRxMDITasks.SelectPrior;
var
  F: TForm;
  Ind, i: Integer;
  C: TControl;
begin
  if not Assigned(FMainPanel) then Exit;

  F:=FMainPanel.CurrentChildWindow;
  if not Assigned(F) then Exit;
  if FMainPanel.ControlCount = 1 then exit;
  Ind:=FMainPanel.GetControlIndex(F);

  for i:=Ind-1 downto 0 do
  begin
    C:=FMainPanel.Controls[i];
    if C is TCustomForm then
    begin
      ShowWindow(TForm(C));
      Exit;
    end;
  end;

  for i:=FMainPanel.ControlCount downto Ind + 1 do
  begin
    C:=FMainPanel.Controls[i];
    if C is TCustomForm then
    begin
      ShowWindow(TForm(C));
      Exit;
    end;
  end;
end;

procedure TRxMDITasks.UpdateMDICaptions;
var
  C: TComponent;
  i: Integer;
begin
  for i:=0 to ComponentCount -1 do
  begin
    C:=Components[i];
    if C is TRxMDIButton then
      TRxMDIButton(C).UpdateCaption;
  end;
end;


{ TRxMDIButton }

procedure TRxMDIButton.SetRxMDIForm(AValue: TForm);
var
  FImageIndex:integer;
  B:TBitmap;
begin
  if FNavForm=AValue then Exit;
  FNavForm:=AValue;
  if Assigned(FNavForm) then
  begin
    FNavForm.AddHandlerClose(@FormClose);

    Caption:=' '+FNavForm.Caption+' ';
    DoCreateButtonImage;

    if Assigned(FNavPanel) then
      FNavPanel.FMainPanel.CurrentChildWindow:=NavForm;
  end;
end;

procedure TRxMDIButton.DoCreateMenuItems;
var
  Item: TMenuItem;
begin
  Item:=TMenuItem.Create(Self);
  Item.Caption:=Caption;
  Item.OnClick:=@DoActivateMenu;
  FMenu.Items.Add(Item);

  Item:=TMenuItem.Create(Self);
  Item.Caption:='-';
  FMenu.Items.Add(Item);

  Item:=TMenuItem.Create(Self);
  Item.Caption:=sCloseWindows;
  Item.OnClick:=@DoCloseMenu;
  FMenu.Items.Add(Item);

  Item:=TMenuItem.Create(Self);
  Item.Caption:='-';
  FMenu.Items.Add(Item);


  Item:=TMenuItem.Create(Self);
  Item.Caption:=sCloseAllExceptThis;
  Item.OnClick:=@DoCloseAllExcepThisMenu;
  FMenu.Items.Add(Item);

  Item:=TMenuItem.Create(Self);
  Item.Caption:=sCloseAllWindows;
  Item.OnClick:=@DoCloseAllMenu;
  FMenu.Items.Add(Item);
end;

procedure TRxMDIButton.DoCloseMenu(Sender: TObject);
begin
  if Assigned(FNavForm) then
    FNavForm.Close;
end;

procedure TRxMDIButton.DoCloseAllMenu(Sender: TObject);
var
  B: Boolean;
begin
  if rxtoAskCloseAll in FNavPanel.Options then
    B:=QuestionDlg(sQuestion, sCloseAllQuestion, mtConfirmation, [mrOk, mrCancel], 0) = mrOK
  else
    B:=true;
  if B then
    FNavPanel.DoCloseAll(nil);
end;

procedure TRxMDIButton.DoCloseAllExcepThisMenu(Sender: TObject);
begin
  FNavPanel.DoCloseAll(Self);
end;

procedure TRxMDIButton.DoActivateMenu(Sender: TObject);
begin
  Click;
end;

procedure TRxMDIButton.DoCreateButtonImage;
var
  FImageIndex:integer;
  B:TBitmap;
begin
  if Assigned(NavForm.Icon) and (NavForm.Icon.Count>0) then
  begin
    B:=TBitmap.Create;
    try
      B.Width:=NavForm.Icon.Width;
      B.Height:=NavForm.Icon.Height;

      B.Canvas.Brush.Color:=Color;
      B.Canvas.FillRect(0,0, B.Width, B.Height);
      B.Canvas.Draw(0, 0, NavForm.Icon);

      Glyph.Assign(B);
    finally
      B.Free;
    end;
  end;
end;

procedure TRxMDIButton.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if (not Assigned(FNavPanel)) or (not Assigned(FNavPanel.FMainPanel)) then
    exit;

  if FNavPanel.FMainPanel.FCurrentChildWindow = Sender then
    FNavPanel.ChildWindowsShowLast;
  FNavPanel.ShowHiddenBtnOnResize;
  CloseAction:=caFree;
  if Assigned(Owner) then
    Owner.RemoveComponent(Self);
  FNavPanel.FMainPanel.RemoveControl(Sender as TCustomForm);
  Application.ReleaseComponent(Self);
  FNavPanel.FMainPanel.RefreshMDIMenu;
end;

procedure TRxMDIButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbMiddle then
  begin
    if Assigned(Owner) then
    begin
      if rxtoMidleClickClose in (Owner as TRxMDITasks).Options then
        DoCloseMenu(Self);
    end;
  end;
end;

procedure TRxMDIButton.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FActiveControl) and (Operation = opRemove) then
    FActiveControl := nil
end;

constructor TRxMDIButton.CreateButton(AOwner: TRxMDITasks; AForm: TForm);
begin
  inherited Create(AOwner);
  FNavPanel:=AOwner;
  Align:=alLeft;
  NavForm:=AForm;
  AutoSize:=true;
  Flat:=AOwner.FlatButton;
  GroupIndex:=1;

  FMenu:=TPopupMenu.Create(Self);
  FMenu.Parent:=Self;
  PopupMenu:=FMenu;
  DoCreateMenuItems;

  AOwner.AddButton(Self);
end;

procedure TRxMDIButton.Click;
begin
  inherited Click;
  if Assigned(FNavForm) then
  begin
    FNavPanel.FMainPanel.HideCurrentWindow;
    FNavForm.Show;
    FNavPanel.FMainPanel.CurrentChildWindow:=NavForm;
    if Assigned(FActiveControl) and FActiveControl.HandleObjectShouldBeVisible then
      FActiveControl.SetFocus;

    if Assigned(FNavPanel.FMainPanel) then
      FNavPanel.FMainPanel.DoOnChangeCurrentChild(FNavForm);
  end;
  Down:=true;

  if Assigned(FNavPanel) then
    FNavPanel.ShowMDIButton(Self);
  FNavPanel.FMainPanel.RefreshMDIMenu;
end;

procedure TRxMDIButton.UpdateCaption;
begin
  if Assigned(FNavForm) then
    Caption:=' '+FNavForm.Caption+' '
  else
    Caption:='---';
  AdjustSize;

  if Assigned(FNavPanel) and Assigned(FNavPanel.FMainPanel) then
    FNavPanel.FMainPanel.RefreshMDIMenu;
end;

initialization
  {$I RxMDICloseIcon.ctrs}
end.

