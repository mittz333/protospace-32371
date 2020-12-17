class PrototypesController < ApplicationController
  # before_action :redirect_to root_path, except: :index unless user_signed_in?
  before_action :authenticate_user!, except: [:index, :show]
  
  def index
    @prototypes = Prototype.all
  end

  def new
    if !user_signed_in?
      redirect_to root_path
    end
    @prototype = Prototype.new
  end

  def create
    # binding.pry
    if Prototype.create(prototype_params).valid?
      # Prototype.create(prototype_params)が重複している気がするが、if文に.valid?を付けないと、
      # 登録できない時でも処理がそのまま進んでトップページに飛ばされてしまうので。

      # 初め、以下のようにPrototype.create(prototype_params).valid?がtrueだったら、改めてPrototype.create(prototype_params)してた。
      # でもこうすると、valid?による判定時含めて、2度DBに書き込んでしまう。ので、↓のPrototype.create(prototype_params)は不要
      # ただ、DBには保存しないけど、DBに登録できるかどうかの判断だけしたい場合は、どうすれば良いのだろう？
      # Prototype.create(prototype_params)
      redirect_to root_path
    else
      # 登録できない時、画面情報を消さずにもう一度登録前の状態の画面に戻したかったのだが、やり方分からず
      # せっかく入れた情報が消えてしまうのが、非常に残念だが・・・。
      # デモ版のはちゃんと出来てるから、なんか手はあるはず。。。
      # ↓以下のように書いたら、行けた！！
      # find使うと、DBからデータ持ってくるのかな？と思うけど、そうでは無いのか・・・。
      # でも、def updateで、登録失敗時に@prototype = Prototype.find(params[:id])としたら、DBからデータ持って来てたし。
      # ここ(create)との違いが分からないなー。
      @prototype = Prototype.find(params[:id])
      render :new
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])
    # binding.pry
    # @prototype.user_idとprototype.user.idの違いを調べた。違い分からず。
    # current_user.idはOKで、current_user_idはNG。両者の違いは？
    unless user_signed_in? && current_user.id == @prototype.user_id
      redirect_to root_path
    end
  end

  def update
    prototype = Prototype.find(params[:id])
    if prototype.update(prototype_params)
      redirect_to prototype_path(params[:id])
    else
      # @prototype = Prototype.find(params[:id])
      @prototype = prototype
      render :edit
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
  end

  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end
end
