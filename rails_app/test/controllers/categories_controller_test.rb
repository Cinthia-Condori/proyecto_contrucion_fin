require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login
    @category = categories(:Clothes)
  end

  test "debería obtener el índice" do
    get categories_url
    assert_response :success
  end

  test "debería obtener nuevo" do
    get new_category_url
    assert_response :success
  end

  test "debería crear una categoría" do
    assert_difference("Category.count") do
      post categories_url, params: { category: { name: @category.name } }
    end

    assert_redirected_to categories_url
  end

  test "editar categoria" do
    get edit_category_url(@category)
    assert_response :success
  end

  test "actualizar categoria" do
    patch category_url(@category), params: { category: { name: @category.name } }
    assert_redirected_to categories_url
  end

  test "eliminar categoria" do
    assert_difference("Category.count", -1) do
      delete category_url(@category)
    end

    assert_redirected_to categories_url
  end
end
