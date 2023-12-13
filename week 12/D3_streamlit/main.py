import pandas as pd
pd.DataFrame.iteritems = pd.DataFrame.items
import numpy as np
import plotly.express as px
import streamlit as st
import pickle
from streamlit_extras.add_vertical_space import add_vertical_space

### Default best practice structure when you have multiple cols:
# Define streamlit_element
# streamlit_element = st.columns, st.sidebar, st.tabs, etc. (see Layouts & Containers in docs)
# with streamlit_element:
    # Write some functions here that define what's inside
    # plotly_fig = px.line(data, x='col1', y='col2')
    # st.plotly_chart(plotly_fig)
    # st.markdown("Some markdown formatted text.")
    
    
### Goal for today: Build and deploy an EDA and ML tool
# Elements we need: data to analyze, some interesting charts, and some model
st.title("Customer Churn - Analysis & Prediction Model")
data = pd.read_csv("https://raw.githubusercontent.com/sabinagio/data-analytics/main/data/customer_churn.csv").dropna()
data['count'] = 1
st.write(data.head())
# st.write(data.dtypes)

# Exploratory Data Analysis
num_vars = data.select_dtypes(np.float64).columns
# st.write(num_vars)
cat_vars = data.drop(num_vars, axis=1).drop('customerID', axis=1).columns
# st.write(cat_vars)
st.markdown("## Exploratory Data Analysis")

row0_spacer1, row0_1, row0_spacer2, row0_2, row0_spacer3 = st.columns(
    (0.01, 2, 0.1, 2, 0.01)
)
with row0_1:
    cat_var = st.selectbox("Categorical variable", cat_vars, key="cat_boxplot")
with row0_2:    
    num_var = st.selectbox("Numerical variable", num_vars, key="num_boxplot")
fig = px.box(data, x=num_var, y=cat_var)
st.plotly_chart(fig)

row1_spacer1, row1_1, row1_spacer2, row1_2, row1_spacer3 = st.columns(
    (0.01, 2, 0.1, 2, 0.01)
)

with row1_1:
    cat_var = st.selectbox("Categorical variable", cat_vars)
    fig = px.histogram(data, x=cat_var, y="count", color='Churn', 
                       barmode='group', 
                       color_discrete_sequence=['green', 'red'])
    st.plotly_chart(fig)
    
with row1_2:
    num_var = st.selectbox("Numerical variable", num_vars)
    fig = px.histogram(data, x=num_var, facet_row='Churn')
    st.plotly_chart(fig)
    
st.markdown("## Prediction Model")

# open pickle files in main (reading the models)
with open("log_reg.pkl", "rb") as li:  # rb: mode read
    log_model = pickle.load(li)

with open("knn.pkl", "rb") as lo:
    knn_model = pickle.load(lo)

with open("bayes.pkl", "rb") as sv:
    bayes_model = pickle.load(sv)
    
st.sidebar.title("Input Parameters")
X_pred = {}

for col in data.drop(['customerID', 'Churn', 'count'], axis=1).columns:
    if data[col].nunique() > 2:
        if data[col].dtype in [np.float64, np.int64]:
            col_value = st.sidebar.slider(col, int(data[col].min()), int(data[col].max()), int(data[col].mean()))
            X_pred[col] = col_value
    else:
        col_value = st.sidebar.selectbox(col, data[col].unique())
        X_pred[col] = col_value
        
X_pred = pd.DataFrame(X_pred, index=[0])
st.write("My customer has the following attributes:")
st.write(X_pred)

# Preprocessing data
from sklearn.preprocessing import MinMaxScaler
scaler = MinMaxScaler()
num_data = data.drop('count', axis=1).select_dtypes(np.number)
scaler.fit(num_data)

X_pred_num = X_pred.select_dtypes(np.number)
X_pred_num_scaled = pd.DataFrame(scaler.transform(X_pred_num), columns=scaler.get_feature_names_out())
# st.write(X_pred_num_scaled)

X_pred_cat = X_pred.select_dtypes(object)
X_pred_cat_encoded = pd.get_dummies(X_pred_cat)
# st.write(X_pred_cat_encoded)

cat_data = data.drop(['customerID', 'Churn'], axis=1).select_dtypes(object)
cat_data_encoded = pd.get_dummies(cat_data)
cat_encoded_cols = cat_data_encoded.columns

data_prep = pd.concat([num_data, cat_data_encoded], axis=1)
prep_columns = data_prep.columns

for col in cat_encoded_cols:
    if col not in X_pred_cat_encoded.columns:
        X_pred_cat_encoded[col] = False
        
# st.write(X_pred_cat_encoded)

X_pred_prep = pd.concat([X_pred_num_scaled, X_pred_cat_encoded], axis=1)

model_options = ['Logistic Regression', 'KNN', 'Naive Bayes']
model = st.selectbox("Select predictive model", model_options)

st.write("Will my customer churn?")
if st.button("Find out"):
    if model == 'Logistic Regression':
        pred = log_model.predict(X_pred_prep[prep_columns])
    elif model == 'KNN':
        pred = knn_model.predict(X_pred_prep[prep_columns])
    elif model == 'Naive Bayes':
        pred = bayes_model.predict(X_pred_prep[prep_columns])
    st.write(pred[0])
     

# Do predictions




