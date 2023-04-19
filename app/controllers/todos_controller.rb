class TodosController < ApplicationController
  def index
    matching_todos = Todo.all

    #matching_todo = @current_user.todos

    @list_of_todos = matching_todos.order({ :created_at => :desc })

    render({ :template => "todos/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_todos = Todo.where({ :id => the_id })

    @the_todo = matching_todos.at(0)

    #render({ :template => "todos/show.html.erb" })
    redirect_to("/")
  end

  def create
    the_todo = Todo.new
    the_todo.user_id = session.fetch(:user_id)
    the_todo.content = params.fetch("query_content")
    the_todo.status = "Next Up"

    if the_todo.valid?
      the_todo.save
      redirect_to("/", { :notice => "Todo created successfully." })
    else
      redirect_to("/", { :alert => the_todo.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    @the_todo = Todo.where({ :id => the_id }).at(0)

    if @the_todo.status == "Next Up"
      @the_todo.status = "In Progress"
    elsif @the_todo.status == "In Progress"
      @the_todo.status = "Done"
    end

    if @the_todo.valid?
      @the_todo.save
      redirect_to("/", { :notice => "Todo updated successfully."} )
    else
      redirect_to("/", { :alert => the_todo.errors.full_messages.to_sentence })
    end

  end

  def destroy
    the_id = params.fetch("path_id")
    the_todo = Todo.where({ :id => the_id }).at(0)

    the_todo.destroy

    redirect_to("/", { :notice => "Todo deleted successfully."} )
  end
end
