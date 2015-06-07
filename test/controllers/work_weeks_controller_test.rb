require 'test_helper'

class WorkWeeksControllerTest < ActionController::TestCase
  setup do
    @work_week = work_weeks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:work_weeks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create work_week" do
    assert_difference('WorkWeek.count') do
      post :create, work_week: { ended_at: @work_week.ended_at, hours: @work_week.hours, invoice_id: @work_week.invoice_id, notes: @work_week.notes, started_at: @work_week.started_at }
    end

    assert_redirected_to work_week_path(assigns(:work_week))
  end

  test "should show work_week" do
    get :show, id: @work_week
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @work_week
    assert_response :success
  end

  test "should update work_week" do
    patch :update, id: @work_week, work_week: { ended_at: @work_week.ended_at, hours: @work_week.hours, invoice_id: @work_week.invoice_id, notes: @work_week.notes, started_at: @work_week.started_at }
    assert_redirected_to work_week_path(assigns(:work_week))
  end

  test "should destroy work_week" do
    assert_difference('WorkWeek.count', -1) do
      delete :destroy, id: @work_week
    end

    assert_redirected_to work_weeks_path
  end
end
